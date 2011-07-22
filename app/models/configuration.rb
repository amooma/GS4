class Configuration < ActiveRecord::Base
	
	validates_presence_of   :name
	validates_uniqueness_of :name
	
	#OPTIMIZE Es muss noch im model abgefangen werden, was nicht gelöscht werden darf, siehe db/seeds.rb. - Vielleicht benötgen wir noch Flags im Modell, welcher Eintrag gelöscht und welcher nur verändet aber nicht ganz gelöscht werden darf. - Ja, das wäre imho sauber.
	
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
