# Model from Cantina API:
#
class Phone < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'phone'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'mac_address'      , 'string'   # string
#		attribute 'phone_model_id'   , 'integer'  # integer
#		attribute 'ip_address'       , 'string'   # string
#		attribute 'last_ip_address'  , 'string'   # string
#		attribute 'http_user'        , 'string'   # string
#		attribute 'http_password'    , 'string'   # string
#		attribute 'created_at'       , 'string'   # datetime
#		attribute 'updated_at'       , 'string'   # datetime
#	end
end

