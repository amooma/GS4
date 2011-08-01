class Configuration < ActiveRecord::Base
	
	validates_presence_of   :name
	validates_uniqueness_of :name
	
	after_save {
		@@conf.clear
	}
	
	@@conf = Hash.new()
	
	#OPTIMIZE Add do_not_delete flag to model, see db/seeds.rb
	
	def self.get( name, default_value = nil, cast_class = nil )
		if (! @@conf.key?( name ))
			config_entry = self.where(:name => name).first
			if config_entry
				if (cast_class != nil)
					@@conf[name] = self.cast_explicitely(config_entry.value, cast_class.name)
				elsif (default_value)
					@@conf[name] = self.cast_explicitely(config_entry.value, default_value.class.name)
				else
					@@conf[name] = config_entry.value
				end
			elsif (cast_class != nil)
				@@conf[name] = self.cast_explicitely(default_value, cast_class.name)
			else
				@@conf[name] = default_value
			end
		end
		
		if (cast_class != nil)
			return self.cast_explicitely(@@conf[name], cast_class.name)
		end
		return @@conf[name]
	end

	def self.cache_clear()
		@@conf.clear
	end
	
	private
	def self.cast_explicitely(value, class_name)
		case class_name
		when 'Fixnum'
			begin
				return Integer(value)
			rescue
				return Integer(0)
			end
		when 'Integer'
			begin
				return Integer(value)
			rescue
				return Integer(0)
			end
		when 'Float'
			begin
				return Float(value)
			rescue
				return Float(0)
			end
		when 'TrueClass'
			return true
		when 'FalseClass'
			return false
		when 'NilClass'
			return nil
		when 'Boolean', 'Configuration::Boolean'
			begin
				return ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
			rescue
				return false
			end
		else
			begin
				return String(value)
			rescue
				return String('')
			end
		end
	end
	
	class Boolean
	end
end

