# Model from Cantina API:
#
class CantinaPhone < ActiveResource::Base
	
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
	
	#has_many :sip_accounts
	#def sip_accounts
	#	return SipAccount.find(:all, :params => { :phone_id => self.id }) || []
	#	# GET "/sip_accounts.xml?phone_id=X"
	#end
end

