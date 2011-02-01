# Model from Cantina API:
#
class Codec < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'codec'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'name'        , 'string'   # string
#		attribute 'created_at'  , 'string'   # datetime
#		attribute 'updated_at'  , 'string'   # datetime
#	end
end

