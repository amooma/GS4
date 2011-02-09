# Model from Cantina API:
#
class CantinaPhoneKey < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'phone_key'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'phone_model_key_id'                , 'integer'  # integer
#		attribute 'phone_key_function_definition_id'  , 'integer'  # integer
#		attribute 'value'                             , 'string'   # string
#		attribute 'label'                             , 'string'   # string
#		attribute 'created_at'                        , 'string'   # datetime
#		attribute 'updated_at'                        , 'string'   # datetime
#		attribute 'sip_account_id'                    , 'integer'  # integer
#	end
end

