# Model from Cantina API:
#
class Oui < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'oui'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'value'            , 'string'   # string
#		attribute 'manufacturer_id'  , 'integer'  # integer
#		attribute 'created_at'       , 'string'   # datetime
#		attribute 'updated_at'       , 'string'   # datetime
#	end
end

