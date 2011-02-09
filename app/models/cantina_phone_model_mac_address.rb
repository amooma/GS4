# Model from Cantina API:
#
class CantinaPhoneModelMacAddress < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'phone_model_mac_address'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'phone_model_id'  , 'integer'  # integer
#		attribute 'starts_with'     , 'string'   # string
#		attribute 'created_at'      , 'string'   # datetime
#		attribute 'updated_at'      , 'string'   # datetime
#	end
end

