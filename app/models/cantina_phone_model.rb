# Model from Cantina API:
#
class CantinaPhoneModel < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'phone_model'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'name'                        , 'string'   # string
#		attribute 'url'                         , 'string'   # string
#		attribute 'manufacturer_id'             , 'integer'  # integer
#		attribute 'max_number_of_sip_accounts'  , 'integer'  # integer
#		attribute 'number_of_keys'              , 'integer'  # integer
#		attribute 'default_http_user'           , 'string'   # string
#		attribute 'default_http_password'       , 'string'   # string
#		attribute 'http_port'                   , 'integer'  # integer
#		attribute 'reboot_request_path'         , 'string'   # string
#		attribute 'ssl'                         , 'string'   # boolean
#		attribute 'http_request_timeout'        , 'integer'  # integer
#		attribute 'created_at'                  , 'string'   # datetime
#		attribute 'updated_at'                  , 'string'   # datetime
#	end
end

