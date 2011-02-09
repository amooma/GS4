# Model from Cantina API:
#
class CantinaPhoneModelCodec < ActiveResource::Base
	
	self.site = 'http://localhost:3001/'
	self.element_name = 'phone_model_codec'
	
#	# http://api.rubyonrails.org/classes/ActiveResource/Base.html#method-c-schema
#	schema do
#		attribute 'phone_model_id'  , 'integer'  # integer
#		attribute 'codec_id'        , 'integer'  # integer
#		attribute 'position'        , 'integer'  # integer
#		attribute 'created_at'      , 'string'   # datetime
#		attribute 'updated_at'      , 'string'   # datetime
#	end
end

