class Configuration < ActiveRecord::Base
	validates_presence_of   :name
	validates_uniqueness_of :name
	
	def self.get( name )
		begin
			return self.where(:name => name).first.value
		rescue
			return nil
		end
	end
end