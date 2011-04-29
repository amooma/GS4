class SipPhone < ActiveRecord::Base
	
	has_many   :sip_accounts, :dependent => :destroy
	belongs_to :provisioning_server, :validate => true
	
	validates_presence_of     :provisioning_server
	
	validates_numericality_of :phone_id, :only_integer => true
	validates_uniqueness_of   :phone_id, :scope => :provisioning_server_id
	
	
	# The provisioning server must never change, once it has been set.
	validate {
		if provisioning_server_id_was != nil \
		&& provisioning_server_id != provisioning_server_id_was
			errors.add( :provisioning_server_id, "must not change. You have to delete the SIP phone and create it on the other provisioning server." )
			return false
		end
	}
	
	# The phone_id must never change, once it has been set.
	#OPTIMIZE Do we still need phone_id?
	validate {
		if phone_id_was != nil \
		&& phone_id != phone_id_was
			errors.add( :phone_id, "must not change. You have to delete the SIP phone and create a new one." )
			return false
		end
	}
	
	# If the phone does not belong to a provisioning server then the
	# phone_id has to be nil.
	validate {
		if provisioning_server_id.blank? && (! phone_id.blank?)
			errors.add( :phone_id, "must be blank if the phone does not belong to a provisioning server." )
			return false
		end
	}
	
	# If the phone belongs to a provisioning server then the phone_id
	# must not be nil.
	validate {
		if (! provisioning_server_id.blank?) && phone_id.blank?
			errors.add( :phone_id, "must not be blank if the phone belongs to a provisioning server." )
			return false
		end
	}
	
	# Validate existence of the phone on the provisioning server.
	after_validation {
		if (! provisioning_server_id.blank?) && (! phone_id.blank?)
			cantina_phone = self.cantina_phone_by_id( phone_id )
			case cantina_phone
				when false
					errors.add( :base, "Failed to connect to the provisioning server." )
					return false
				when nil
					errors.add( :phone_id, "does not exist on the provisioning server." )
					return false
				else
					return true
			end
		end
	}
	
	def cantina_phone_by_id( cantina_phone_id )
		cantina_resource = provisioning_server_base_url()
		if ! cantina_resource
			# SipPhone has no provisioning server.
			return nil
		end
		logger.debug "Trying to find CantinaPhone with ID #{cantina_phone_id.inspect} on #{cantina_resource.inspect} ..."
		begin
			#OPTIMIZE Remove CantinaPhone.
			CantinaPhone.set_resource( cantina_resource )
			cantina_phone = CantinaPhone.find( cantina_phone_id )
			return cantina_phone || nil
		rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, Errno::EHOSTDOWN, ActiveResource::TimeoutError => e
			logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
			return false
		end
	end
	
	def provisioning_server_base_url
		scheme = 'http'
		host   = '0.0.0.0'  # this will not work on purpose
		port   = 0          # this will not work on purpose
		path   = '/'
		
		if self.provisioning_server_id.blank? || ! self.provisioning_server
			logger.debug "SipPhone #{self.id.inspect} has no provisioning server. Alright."
			return nil  # phone without provisioning
		else
			prov_server = self.provisioning_server
			if prov_server
				scheme = 'http'  # TODO - https as soon as it is implemented.
				host   = prov_server.name if ! prov_server.name.blank?
				port   = prov_server.port if ! prov_server.port.blank?
				path   = '/'
			end
		end
		
		ret = '%s://%s%s%s' % [
			scheme,
			host,
			port.blank? ? '' : ":#{port.to_s}",
			path,
		]
		logger.debug "SipPhone #{self.id.inspect} has prov. server #{ret.inspect}."
		return ret
	end
	
end

