class SipPhone < ActiveRecord::Base
	
	has_many   :sip_accounts, :dependent => :destroy
	belongs_to :provisioning_server, :validate => true
	
	validates_presence_of :provisioning_server
	
	#FIXME Validate existence of sip_phone on provisioning_server BEFORE create!

	# phone_id on provisioning_server must be unique.
	validates_uniqueness_of( :phone_id, :scope => "provisioning_server_id" )
	
	# The provisioning server must never change, once it has been set.
	validate {
		if provisioning_server_id_was != nil \
		&& provisioning_server_id != provisioning_server_id_was
			errors.add( :provisioning_server_id, "must not change. You have to delete the SIP phone and create it on the other provisioning server." )
		end
	}
	
	# The phone_id must never change, once it has been set.
	validate {
		if phone_id_was != nil \
		&& phone_id != phone_id_was
			errors.add( :phone_id, "must not change. You have to delete the SIP phone and create a new one." )
		end
	}
	
	# If the phone does not belong to a provisioning server then the
	# phone_id has to be nil.
	validate {
		if provisioning_server_id.blank? && (! phone_id.blank?)
			errors.add( :phone_id, "must be blank if the phone does not belong to a provisioning server." )
		end
	}
	
	# If the phone belongs to a provisioning server then the phone_id
	# must not be nil.
	validate {
		if (! provisioning_server_id.blank?) && phone_id.blank?
			errors.add( :phone_id, "must not be blank if the phone belongs to a provisioning server." )
		end
	}
	
end

