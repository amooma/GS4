# Model from Cantina API:
#
class PhoneKeyFunctionDefinition < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'phone_key_function_definition'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'name'              , 'string'   # string
#		attribute 'type_of_class'     , 'string'   # string
#		attribute 'regex_validation'  , 'string'   # string
#		attribute 'created_at'        , 'string'   # datetime
#		attribute 'updated_at'        , 'string'   # datetime
#	end
end

