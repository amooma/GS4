# == Schema Information
# Schema version: 20110209212927
#
# Table name: sip_accounts
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  auth_name     :string(255)
#  password      :string(255)
#  realm         :string(255)
#  phone_number  :integer
#  sip_server_id :integer
#  sip_proxy_id  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  extension_id  :integer
#  sip_phone_id  :integer
#

class SipAccount < ActiveRecord::Base
	
	belongs_to :sip_server , :validate => true
	belongs_to :sip_proxy  , :validate => true
	belongs_to :sip_phone  , :validate => true
	belongs_to :extension  , :validate => true
	belongs_to :user      
	
	validates_presence_of :sip_phone_id
	
	# The SipAccount must stay on the same provisioning server or
	# bad things may happen.
	validate {
		if sip_phone_id_was != nil \
		&& sip_phone_id != sip_phone_id_was
			prov_server_id_is  = SipPhone.find( sip_phone_id     ).provisioning_server_id
			prov_server_id_was = SipPhone.find( sip_phone_id_was ).provisioning_server_id
			if prov_server_id_is != prov_server_id_was
				errors.add( :sip_phone, "must stay on the same provisioning server (ID #{prov_server_id_was.inspect})." )
			end
		end
	}
	
	after_validation :prov_srv_sip_account_create, :on => :create
	after_validation :prov_srv_sip_account_update, :on => :update
	before_destroy   :prov_srv_sip_account_destroy
	
	
#	# http://rubydoc.info/docs/rails/3.0.0/ActiveModel/Dirty
# 	include ActiveModel::Dirty
# 	
# 	define_attribute_methods [:sip_server]
# 	
# 	def sip_server
# 		@sip_server
# 	end
# 	
# 	def sip_server=(val)
# 		name_will_change! unless val == @sip_server
# 		@sip_server = val
# 	end
# 	
# 	def save
# 		@previously_changed = changes
# 		@changed_attributes.clear
# 	end
	
	
	# Returns the corresponding SIP account from Cantina.
	# Returns the CantinaSipAccount if found or nil if not found or
	# false on error.
	#
	def cantina_sip_account
		return cantina_find_sip_account_by_server_and_user(
			(self.sip_server ? self.sip_server.name : nil),
			self.auth_name
		)
	end
	
	private
	
	# Create SIP account on the provisioning server.
	#
	def prov_srv_sip_account_create
		prov_srv = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
		ret = false
		if self.errors && self.errors.length > 0
			# The SIP account is invalid. Don't even try to create it on the prov. server.
			errors.add( :base, "Will not create invalid SIP account on the provisioning server." )
		else
			case prov_srv
				when 'cantina'
					ret = cantina_sip_account_create
				else
					errors.add( :base, "Provisioning server type #{prov_srv.inspect} not implemented." )
			end
		end
		return ret
	end
	
	# Update SIP account on the provisioning server.
	#
	def prov_srv_sip_account_update
		prov_srv = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
		ret = false
		if self.errors && self.errors.length > 0
			# The SIP account is invalid. Don't even try to update it on the prov. server.
			errors.add( :base, "SIP account is invalid. Will not update data on the provisioning server." )
		else
			case prov_srv
				when 'cantina'
					ret = cantina_sip_account_update
				else
					errors.add( :base, "Provisioning server type #{prov_srv.inspect} not implemented." )
			end
		end
		return ret
	end
	
	# Delete SIP account on the provisioning server.
	#
	def prov_srv_sip_account_destroy
		prov_srv = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
		ret = false
		case prov_srv
			when 'cantina'
				ret = cantina_sip_account_destroy
			else
				errors.add( :base, "Provisioning server type #{prov_srv.inspect} not implemented." )
		end
		return ret
	end
	
	# Returns the appropriate "site" parameter URL to use for the
	# CantinaSipAccount ActiveResource. Returns nil if the SipPhone
	# corresponding to this SipAccount does not have provisioning.
	#
	def determine_prov_server_resource
		scheme = 'http'
		host   = '0.0.0.0'  # this will not work on purpose
		port   = 0          # this will not work on purpose
		path   = '/'
		if self.sip_phone
			if self.sip_phone.provisioning_server_id.blank?
				logger.debug "SipPhone #{self.sip_phone_id.inspect} has no provisioning server. Alright."
				return nil  # phone without provisioning
			else
				prov_srv = self.sip_phone.provisioning_server
				if prov_srv
					scheme = 'http'  # TODO - https?
					host   = prov_srv.name if ! prov_srv.name.blank?
					port   = prov_srv.port if ! prov_srv.port.blank?
					path   = '/'
				end
			end
		end
		ret = '%s://%s%s%s' % [
			scheme,
			host,
			port.blank? ? '' : ":#{port.to_s}",
			path,
		]
		logger.debug "SipPhone #{self.sip_phone_id.inspect} has prov. server #{ret.inspect}."
		return ret
	end
	
	# Find a SIP account by SIP server and SIP user on the Cantina
	# provisioning server.
	# Returns the CantinaSipAccount if found or nil if not found or
	# false on error.
	#
	def cantina_find_sip_account_by_server_and_user( sip_server, sip_user )
		logger.debug "Trying to find Cantina SIP account for \"#{sip_user}@#{sip_server}\" ..."
		begin
			cantina_resource = determine_prov_server_resource()
			if ! cantina_resource
				# SipPhone has no provisioning server.
				return nil
			else
				CantinaSipAccount.set_resource( cantina_resource )
				cantina_sip_accounts = CantinaSipAccount.all()
				# GET "/sip_accounts.xml" - #OPTIMIZE - The Cantina API does not let us do more advanced queries so we have to get all SIP accounts.
				if cantina_sip_accounts
					cantina_sip_accounts.each { |cantina_sip_account|
						if cantina_sip_account.registrar .to_s == sip_server .to_s \
						&& cantina_sip_account.user      .to_s == sip_user   .to_s
							logger.debug "Found CantinaSipAccount ID #{cantina_sip_account.id}."
							return cantina_sip_account
							break
						end
					}
				end
				logger.debug "CantinaSipAccount not found."
				return nil
			end
		rescue Errno::ECONNREFUSED => e
			return false
		end
	end
	
	# Create SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_create
		begin
			cantina_resource = determine_prov_server_resource()
			if ! cantina_resource
				return true
			else
				CantinaSipAccount.set_resource( cantina_resource )
				cantina_sip_account = CantinaSipAccount.create({
					:name            => "a SIP account from Gemeinschaft (#{Time.now.to_i}-#{self.object_id})",
					:auth_user       => self.auth_name,
					:user            => self.phone_number,
					:password        => self.password,
					:realm           => self.realm,
					:phone_id        => (self.sip_phone ? self.sip_phone.phone_id : nil),
					:registrar       => (self.sip_server ? self.sip_server.name : nil),
					:registrar_port  => nil,
					:sip_proxy       => (self.sip_proxy ? self.sip_proxy.name : nil),
					:sip_proxy_port  => nil,
					:registration_expiry_time => 300,
					:dtmf_mode       => 'rfc2833',
				})
				log_active_record_errors_from_remote( cantina_sip_account )
				return true
			end
		rescue Errno::ECONNREFUSED => e
			logger.warn "Failed to connect to Cantina provisioning server. (#{e.class}, #{e.message})"
			errors.add( :base, "Failed to connect to Cantina provisioning server." )
			return false
		end
		
		if ! cantina_sip_account.valid?
			errors.add( :base, "Failed to create SIP account on Cantina provisioning server. (Reason:\n" +
				get_active_record_errors_from_remote( cantina_sip_account ).join(",\n") +
				")" )
			return false
		end
	end
	
	# Update SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_update
		sip_server_was = self.sip_server_id_was ? SipServer.find( self.sip_server_id_was ) : nil
		cantina_sip_account = cantina_find_sip_account_by_server_and_user(
			(sip_server_was ? sip_server_was.name : nil),
			self.auth_name_was
		)
		
		case cantina_sip_account
			when false
				errors.add( :base, "Failed to connect to Cantina provisioning server." )
				return false
			when nil
				# create instead
				return cantina_sip_account_create
			else
				if ! cantina_sip_account.update_attributes({
					:auth_user       => self.auth_name,
					:user            => self.phone_number,
					:password        => self.password,
					:realm           => self.realm,
					:phone_id        => (self.sip_phone ? self.sip_phone.phone_id : nil),
					:registrar       => (self.sip_server ? self.sip_server.name : nil),
					:registrar_port  => nil,
					:sip_proxy       => (self.sip_proxy ? self.sip_proxy.name : nil),
					:sip_proxy_port  => nil,
					:registration_expiry_time => 300,
					:dtmf_mode       => 'rfc2833',
				})
					log_active_record_errors_from_remote( cantina_sip_account )
					errors.add( :base, "Failed to update SIP account on Cantina provisioning server. (Reason:\n" +
						get_active_record_errors_from_remote( cantina_sip_account ).join(",\n") +
						")" )
					return false
				end
		end
		return true
	end
	
	# Delete SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_destroy
		sip_server_was = self.sip_server_id_was ? SipServer.find( self.sip_server_id_was ) : nil
		cantina_sip_account = cantina_find_sip_account_by_server_and_user(
			(sip_server_was ? sip_server_was.name : nil),
			self.auth_name_was
		)
		
		case cantina_sip_account
			when false
				errors.add( :base, "Failed to connect to Cantina provisioning server." )
				return false
			when nil
				# no action required
			else
				if ! cantina_sip_account.destroy
					errors.add( :base, "Failed to delete SIP account on Cantina provisioning server. (Reason:\n" +
						get_active_record_errors_from_remote( cantina_sip_account ).join(",\n") +
						")" )
					return false
				end
		end
		return true
	end
	
	# Log validation errors from the remote model.
	#
	def log_active_record_errors_from_remote( ar )
		if ar.respond_to?(:errors) && ar.errors.kind_of?(Hash)
			logger.info "----------------------------------------------------------"
			logger.info "Errors for #{ar.class} from Cantina:"
			ar.errors.each_pair { |attr, errs|
				logger.info "  :#{attr.to_s}"
				if errs.kind_of?(Array) && errs.length > 0
					errs.each { |msg|
						logger.info "    " + (attr == :base ? '' : ":#{attr.to_s} ") + "#{msg}"
					}
				end
			}
			logger.info "----------------------------------------------------------"
		end
	end
	
	# Get validation errors from the remote model.
	#
	def get_active_record_errors_from_remote( ar )
		ret = []
		if ar.respond_to?(:errors) && ar.errors.kind_of?(Hash)
			ar.errors.each_pair { |attr, errs|
				if errs.kind_of?(Array) && errs.length > 0
					errs.each { |msg|
						ret << ( '' + (attr == :base ? '' : "#{attr.to_s} ") + "#{msg}" )
					}
				end
			}
		end
		return ret
	end
	
end
