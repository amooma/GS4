require 'active_resource'

class ActiveResource::Base
	
	self.site = 'http://0.0.0.0:0/'
	self.element_name = 'invalid'
	
	# Allows you to set the provisioning server for the Cantina* models.
	#
	def self.set_resource( site, element_name )
		self.site         = site
		self.element_name = element_name
		return true
	end
end

