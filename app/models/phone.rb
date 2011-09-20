require 'scanf'

class Phone < ActiveRecord::Base
	
	#OPTIMIZE Combine Phone and SipPhone into one model?
	
	before_validation :format_mac_address
	
	validates_presence_of     :mac_address
	validates_format_of       :mac_address, :with => /^ [0-9A-F]{2} (?: [0-9A-F]{2} ){5} $/x
	validates_uniqueness_of   :mac_address
	
	validates_uniqueness_of   :ip_address, :allow_nil => true, :allow_blank => true
	validates_format_of       :ip_address, :with => /^ (?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d) (?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3} $/x, :allow_blank => true, :allow_nil => true
	
	validates_numericality_of :phone_model_id, :greater_than => 0
	validates_presence_of     :phone_model
	
	validate :cross_check_mac_address_with_ouis, :if => Proc.new { |phone| ! phone.mac_address.blank? && ! (phone.errors[:mac_address].count > 0) }
	
	after_validation :save_old_last_ip_address
	
	
	has_many    :sip_accounts, :order => 'position'
	
	has_many    :phone_keys, :through => :sip_accounts
	
	has_many    :provisioning_log_entries, :order => 'created_at'
	
	belongs_to  :phone_model
	
	has_many    :reboot_requests, :order => 'start', :dependent => :destroy
	
	accepts_nested_attributes_for :sip_accounts
	
	# log a provisioning
	#
	def log_provisioning( memo=nil, succeeded=true )
		self.provisioning_log_entries.create( :memo => memo, :succeeded => true )
	end
	
	# Is the system able to reboot this phone?
	#
	def rebootable?
		return (
			(! self.ip_address.blank?) &&
			(! self.phone_model.reboot_request_path.blank?)
		)
	end
	
	# Reboots this phone
	#
	def reboot
	(
		if ! self.rebootable?; return true; end
		begin
		(
			reboot_request = RebootRequest.create( :phone_id => self.id )
			require 'net/http'
			
			http = Net::HTTP.new( self.ip_address, self.phone_model.http_port )
			if (http); (
				http.use_ssl      = self.phone_model.ssl
				http.open_timeout = self.phone_model.http_request_timeout
				http.read_timeout = self.phone_model.http_request_timeout
				
				if (self.http_user     .blank?) \
				&& (self.http_password .blank?)
					self.http_user     = self.phone_model.default_http_user
					self.http_password = self.phone_model.default_http_password
				end
				
				#OPTIMIZE Run reboot requests as background jobs?
				
				if self.phone_model.manufacturer.ieee_name == "DeTeWe-Deutsche Telephonwerke" \
				&& self.phone_model.reboot_request_path == 'logout.html'
					
					request = Net::HTTP::Get.new( 'logout.html', nil )
					request.basic_auth( self.http_user, self.http_password )
					response = http.request( request )
					
					request = Net::HTTP::Get.new( 'logout.html', nil )
					request.basic_auth( self.http_user, self.http_password )
					response = http.request( request )
					
					request = Net::HTTP::Post.new( 'reset.html', nil )
					request.set_form_data({ 'resetOption' => '0' })
					request.basic_auth( self.http_user, self.http_password )
					response = http.request( request )
					
				elsif self.phone_model.manufacturer.ieee_name == "XIAMEN YEALINK NETWORK TECHNOLOGY CO.,LTD" \
				&&    self.phone_model.reboot_request_path == '/cgi-bin/ConfigManApp.com'
					
					request = Net::HTTP::Post.new( '/cgi-bin/ConfigManApp.com', nil )
					request.set_form_data({ 'PAGEID' => '7', 'CONFIG_DATA' => 'REBOOT' })
					request.basic_auth( self.http_user, self.http_password )
					response = http.request( request )
				else
					request = Net::HTTP::Get.new( self.phone_model.reboot_request_path, nil )
					request.basic_auth( self.http_user, self.http_password )
					response = http.request( request )
				end
				
				success = case response.code
					when '200'; true
					when '302'; true
					else      ; false
				end
				reboot_request.update_attributes({
					:end        => Time.now,
					:successful => success,
				})
				return success
			)end
			return false
		)
		rescue => error
		(
			reboot_request.update_attributes({
				:end        => Time.now,
				:successful => false,
			})
			return false  #OPTIMIZE Try again later?
		)end
	)end
	
	def mac_address_to_display
		return [].fill('%02X', 0, 6).join(':') % self.mac_address.scanf( '%2X' * 6 )
	end
	
	# The phone can be reached by dialing on of the extensions in this array.
	#
	def extensions
		(self.sip_accounts || []).map{ |sip_account| sip_account.extensions }.flatten
	end  
	
	private
	
	# Formats a MAC address.
	#
	def format_mac_address
		self.mac_address = self.mac_address.to_s().upcase().gsub( /[^A-F0-9]/, '' )
	end
	
	# Saves the last IP address
	#
	def save_old_last_ip_address
		if self.ip_address_changed? \
		&& self.ip_address != self.ip_address_was
			self.last_ip_address = self.ip_address_was
		end
	end
	
	# Make sure that a given MAC address really belongs to a given manufacturer
	#
	def cross_check_mac_address_with_ouis
		oui_str = self.mac_address.to_s().upcase().gsub( /[^A-F0-9]/, '' )[0,6]
		oui_obj = Oui.where( :value => oui_str ).first
		if oui_obj == nil \
		|| (self.phone_model && self.phone_model.try(:manufacturer) != oui_obj.manufacturer)
			errors.add( :mac_address, I18n.t(:mac_address_not_matching_oui, :manufacturer => self.phone_model.try(:manufacturer).try(:name) ))
		end
	end
	
end
