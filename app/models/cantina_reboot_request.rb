# Model from Cantina API:
#
class CantinaRebootRequest < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'reboot_request'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'phone_id'    , 'integer'  # integer
#		attribute 'start'       , 'string'   # datetime
#		attribute 'end'         , 'string'   # datetime
#		attribute 'successful'  , 'string'   # boolean
#		attribute 'created_at'  , 'string'   # datetime
#		attribute 'updated_at'  , 'string'   # datetime
#	end
end

