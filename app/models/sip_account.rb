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
	belongs_to :user       , :validate => true
	
	validates_presence_of :sip_phone_id
	validates_presence_of :user_id
	
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
	
	
	# Find a SIP account by SIP server and SIP user on the Cantina
	# provisioning server.
	# Returns the CantinaSipAccount if found or nil if not found or
	# false on error.
	#
	def cantina_find_sip_account_by_server_and_user( sip_server, sip_user )
		logger.debug "Trying to find Cantina SIP account for \"#{sip_user}@#{sip_server}\" ..."
		begin
			cantina_sip_accounts = CantinaSipAccount.all()
			# GET "/sip_accounts.xml" - #OPTIMIZE - The Cantina API does not let us do more advanced queries so we have to get all SIP accounts.
			if cantina_sip_accounts
				cantina_sip_accounts.each { |cantina_sip_account|
					if cantina_sip_account.sip_proxy .to_s == sip_server .to_s \
					&& cantina_sip_account.user      .to_s == sip_user   .to_s
						logger.debug "Found CantinaSipAccount ID #{cantina_sip_account.id}."
						return cantina_sip_account
						break
					end
				}
			end
			logger.debug "CantinaSipAccount not found."
			return nil
		rescue Errno::ECONNREFUSED => e
			return false
		end
	end
	
	# Create SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_create
		begin
			cantina_sip_account = CantinaSipAccount.create({
				:name            => "a SIP account from Gemeinschaft (#{Time.now.to_i}-#{self.object_id})",
				:auth_user       => self.auth_name,
				:user            => self.auth_name,
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
		rescue Errno::ECONNREFUSED => e
			logger.warn "Failed to connect to Cantina provisioning server. (#{e.class}, #{e.message})"
			errors.add( :base, "Failed to connect to Cantina provisioning server." )
			return false
		end
		
		if ! cantina_sip_account.valid?
			errors.add( :base, "Failed to create SIP account on Cantina provisioning server." )
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
					:user            => self.auth_name,
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
					errors.add( :base, "Failed to update SIP account on Cantina provisioning server." )
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
					errors.add( :base, "Failed to delete SIP account on Cantina provisioning server." )
					return false
				end
		end
		return true
	end
	
	# Log validation errors from the remote model.
	#
	def log_active_record_errors_from_remote( ar )
		logger.info ar.valid?.inspect
		
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
	
end
