# Model from Cantina API:
#
class CantinaProvisioningLogEntry < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'provisioning_log_entry'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'phone_id'    , 'integer'  # integer
#		attribute 'memo'        , 'string'   # string
#		attribute 'succeeded'   , 'string'   # boolean
#		attribute 'created_at'  , 'string'   # datetime
#		attribute 'updated_at'  , 'string'   # datetime
#	end
end

