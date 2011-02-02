# Model from Cantina API:
#
class SipAccount < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'sip_account'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'name'                      , 'string'   # string
#		attribute 'phone_id'                  , 'integer'  # integer
#		attribute 'auth_user'                 , 'string'   # string
#		attribute 'user'                      , 'string'   # string
#		attribute 'password'                  , 'string'   # string
#		attribute 'registrar'                 , 'string'   # string
#		attribute 'registrar_port'            , 'integer'  # integer
#		attribute 'outbound_proxy'            , 'string'   # string
#		attribute 'outbound_proxy_port'       , 'integer'  # integer
#		attribute 'sip_proxy'                 , 'string'   # string
#		attribute 'sip_proxy_port'            , 'integer'  # integer
#		attribute 'realm'                     , 'string'   # string
#		attribute 'screen_name'               , 'string'   # string
#		attribute 'display_name'              , 'string'   # string
#		attribute 'registration_expiry_time'  , 'integer'  # integer
#		attribute 'dtmf_mode'                 , 'string'   # string
#		attribute 'remote_password'           , 'string'   # string
#		attribute 'position'                  , 'integer'  # integer
#		attribute 'created_at'                , 'string'   # datetime
#		attribute 'updated_at'                , 'string'   # datetime
#	end
  
end

