class Configuration < ActiveRecord::Base
	
	validates_presence_of   :name
	validates_uniqueness_of :name
	
	def self.get( name, default_value = nil )
		begin
			return self.where(:name => name).first.value
		rescue
			return default_value ? default_value.to_s : nil
		end
		
		#OPTIMIZE Don't use exceptions for normal control flow.
		#config = self.where(:name => name).first
		#return config.value if config
		#return default_value ? default_value.to_s : nil
	end
end
