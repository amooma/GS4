class Configuration < ActiveRecord::Base
	
	validates_presence_of   :name
	validates_uniqueness_of :name
	
	after_save {
		@@conf.clear
	}
	
	@@conf = Hash.new()
	
	#OPTIMIZE Add do_not_delete flag to model, see db/seeds.rb
	
	def self.get( name, default_value = nil )
		if @@conf.key?( name )
			return @@conf[name]
		end
		
		config_entry = self.where(:name => name).first
		if config_entry
			@@conf[name] = config_entry.value
		else
			@@conf[name] = default_value ? default_value.to_s : nil
		end
		return @@conf[name]
	end

	def self.cache_clear()
		@@conf.clear
	end
	
end
