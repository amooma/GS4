# Some simplified wrappers around Configuration.get().
#
module Cfg
	
	# Simple wrapper for Configuration.get().
	#
	# You need to do the casting yourself.
	# Comparison:
	#   value = Configuration.get( :foo, 42, Integer )
	#   vs.
	#   value = ( Cfg.get(:foo) || 42 ).to_i
	#
	def self.get( name )
		return Configuration.get( name.to_sym )
	end
	
	# Simple wrapper.
	#
	# Returns a configuration value (if set) as a string or the
	# default value (if passed as an argument) as a string or nil.
	#
	# Comparison:
	#   value = Configuration.get( :foo, "bar", String )
	#   vs.
	#   value = ( Cfg.get(:foo) || "bar" ).to_s
	#   vs.
	#   value = Cfg.str( :foo, "bar" )
	#
	def self.str( name, default = nil )
		value = Cfg.get( name )
		return (value         .to_s) if value
		return (default       .to_s) if default
		return nil
	end
	
	# Simple wrapper.
	#
	# Returns a configuration value (if set) as an integer or the
	# default value (if passed as an argument) as an integer or nil.
	#
	# Comparison:
	#   value = Configuration.get( :foo, 42, Integer )
	#   vs.
	#   value = ( Cfg.get(:foo) || 42 ).to_i
	#   vs.
	#   value = Cfg.int( :foo, 42 )
	#
	def self.int( name, default = nil )
		value = Cfg.get( name )
		return (value         .to_i) if value
		return (default       .to_i) if default && default.respond_to?(:to_i)
		return (default .to_s .to_i) if default
		return nil
	end
	
	# Simple wrapper.
	#
	# Returns a configuration value (if set) as a boolean or the
	# default value (if passed as an argument) as a boolean or nil.
	#
	# Comparison:
	#   value = Configuration.get( :foo, false, Configuration::Boolean )
	#   vs.
	#   value = !! ( Cfg.get(:foo) || false )
	#   vs.
	#   value = Cfg.bool( :foo, false )
	#   resp.
	#   value = Configuration.get( :foo, nil, Configuration::Boolean )
	#   vs.
	#   value = Cfg.bool( :foo )
	#
	# Examples:
	#   Cfg.bool( :not_defined, true  )   # == true
	#   Cfg.bool( :not_defined, false )   # == false
	#   Cfg.bool( :not_defined, nil   )   # == nil
	#   Cfg.bool( :not_defined        )   # == nil
	#
	def self.bool( name, default = nil )
		value = Cfg.get( name )
		if value != nil
			begin
				return ActiveRecord::ConnectionAdapters::Column.value_to_boolean( value )
			rescue
			end
		end
		return (!! default) if default != nil
		return nil
	end

end
