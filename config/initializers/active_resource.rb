require 'active_resource'

class ActiveResource::Base
	
	self.site = 'http://0.0.0.0:0/'
	self.element_name = 'invalid'
	self.timeout = 10  # the default value of 60 seconds is way too high
	
	# Allows you to set the provisioning server for the Cantina* models.
	#
	def self.set_resource( site, element_name=nil )
		
		site = (site + '/') if ! site.end_with?('/')
		
		self.site         = site         .to_s.dup
		self.element_name = element_name .to_s.dup  if ! element_name.blank?
		
		return true
	end
end

# Enable logging for ActiveResource:
ActiveResource::Base.logger = ActionController::Base.logger
#ActiveResource::Base.logger = ActiveRecord::Base.logger

