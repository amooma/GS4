class SipAccount < ActiveRecord::Base
	
	belongs_to :sip_server, :validate => true
	belongs_to :sip_proxy, :validate => true
	
	after_validation :prov_srv_sip_account_create, :on => :create
	after_validation :prov_srv_sip_account_update, :on => :update
	after_destroy    :prov_srv_sip_account_destroy
	
	# Returns the corresponding SIP account from Cantina.
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
		case prov_srv
			when 'cantina'
				ret = cantina_sip_account_create
			else
				errors.add( :base, "Provisioning server type #{prov_srv.inspect} not implemented." )
		end
		return ret
	end
	
	# Update SIP account on the provisioning server.
	#
	def prov_srv_sip_account_update
		prov_srv = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
		ret = false
		case prov_srv
			when 'cantina'
				ret = cantina_sip_account_update
			else
				errors.add( :base, "Provisioning server type #{prov_srv.inspect} not implemented." )
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
		begin
			cantina_sip_accounts = CantinaSipAccount.all()  # GET "/sip_accounts.xml" - #OPTIMIZE
			if cantina_sip_accounts
				cantina_sip_accounts.each { |cantina_sip_account|
					if cantina_sip_account.sip_proxy == sip_server \
					&& cantina_sip_account.user      == sip_user
						return cantina_sip_account
						break
					end
				}
			end
			return nil
		rescue Errno::ECONNREFUSED => e
			return false
		end
	end
	
	
	# Get SIP account from the Cantina provisioning server.
	#
	def cantina_sip_account_get
		
		
	end
	
	# Create SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_create
		begin
			cantina_sip_account = CantinaSipAccount.create(
				:name            => "a SIP account from Gemeinschaft (#{Time.now.to_i}-#{self.object_id})",
				:auth_user       => self.auth_name,
				:user            => self.auth_name,
				:password        => self.password,
				:realm           => self.realm,
				:phone_id        => nil,              #TODO
				:registrar       => (self.sip_server ? self.sip_server.name : nil),
				:registrar_port  => nil,
				:sip_proxy       => (self.sip_proxy ? self.sip_proxy.name : nil),
				:sip_proxy_port  => nil,
				:registration_expiry_time => 300,
				:dtmf_mode       => 'rfc2833',
			)
		rescue Errno::ECONNREFUSED => e
			logger.warn "Failed to connect to Cantina provisioning server. (#{e.class}, #{e.message})"
			errors.add( :base, "Failed to connect to Cantina provisioning server." )
			return false
		end
		
		log_active_record_errors_from_remote( cantina_sip_account )
		
		if ! cantina_sip_account.valid?
			errors.add( :base, "Failed to create SIP account on Cantina provisioning server." )
			return false
		end
	end
	
	# Update SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_update
		#TODO
		errors.add( :base, "Failed to update SIP account on Cantina provisioning server." )
		return false
	end
	
	# Delete SIP account on the Cantina provisioning server.
	#
	def cantina_sip_account_destroy
		#TODO
		errors.add( :base, "Failed to delete SIP account on Cantina provisioning server." )
		return false
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
