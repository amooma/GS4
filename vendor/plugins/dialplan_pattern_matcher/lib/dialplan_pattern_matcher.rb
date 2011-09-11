require 'active_support/inflector'


module DialplanPatternMatcher
	
	class DialplanPatternInvalidError < ::ArgumentError
	end
	
	module PatternTypeRegistry
		
		@@pattern_classes = []
		@@pattern_types = {}
		
		def initialize
			raise RuntimeError.new( "Do not instantiate %s." % [ self.class.to_s ] )
		end
		
		def self.pattern_classes
			return @@pattern_classes
		end
		
		def self.pattern_types
			return @@pattern_types
		end
		
		def self.register_pattern_class( klass )
			Logger.debug "Registering pattern class %s." % [ klass.to_s.demodulize ]
			klass.class == Class ||
				raise( ::ArgumentError.new( "Class must be a class." ))
			@@pattern_classes << klass
		end
		
		def self.register_pattern_types
			@@pattern_classes.each { |klass|
				self.register_pattern_type( klass.pattern_type, klass )
			}
		end
		
		private
		
		def self.register_pattern_type( pattern_type, klass )
			Logger.debug "Registering pattern type %s, handled by %s." % [ pattern_type.to_s.inspect, klass.to_s.demodulize ]
			pattern_type.respond_to?(:to_sym) ||
				raise( ::ArgumentError.new( "Pattern type must be symbol-ish." ))
			klass.class == Class ||
				raise( ::ArgumentError.new( "Class must be a class." ))
			@@pattern_types[ pattern_type.to_sym ] = klass
		end
		
	end
	
	def self.pattern_class_for_type( type )
		return PatternTypeRegistry.pattern_types[ type.to_sym ]
	end
	
	def self.pattern( type, pattern_str )
		klass = self.pattern_class_for_type( type )
		return klass ? klass.new( pattern_str ) : nil
	end
	
	
	
	
=begin
	class Context
	end
	
	def self.match( pattern_type, pattern, dialstring )
		m = MatchResult.new
		m.error = "ERROR"
		return m
	end
	
	#class MatchResult
	#	
	#	attr_accessor :error
	#	
	#	def initialize
	#		@error = nil
	#	end
	#end
	
	class MatchResult < Struct.new( :error )
	end
=end
	
end


def DPP( type, pattern )
	return DialplanPatternMatcher.pattern( type, pattern )
end









module DialplanPatternMatcher
module Utils
	
=begin
	# Makes an underscored, lowercase form from a camel-case class name.
	# Changes "::" to "/" to convert namespaces to filesystem paths.
	# 
	# See activesupport/lib/active_support/inflector/methods.rb
	#
	# Examples:
	#   "ActiveRecord"         .underscore  # => "active_record"
	#   "ActiveRecord::Errors" .underscore  # => "active_record/errors"
	#   "SSLError"             .underscore  # => "ssl_error"
	#
	def self.underscore( klass )
		ret = klass.to_s.dup
		ret.gsub!( /::/, '/' )
		ret.gsub!( /([A-Z]+)([A-Z][a-z])/, '\1_\2' )
		ret.gsub!( /([a-z\d])([A-Z])/, '\1_\2' )
		ret.tr!( '-', '_' )
		ret.downcase!
		ret
	end
=end
	
	def self.class_name_to_file_basename( class_name )
		#return self.underscore( class_name )
		return class_name.to_s.underscore
	end
	
end
end




module DialplanPatternMatcher
module MatcherHelpers
	
	# Helper method for sub-classes. Returns a plain Regexp without a language.
	
	def str_to_regexp( str )
		return Regexp.new( str.to_s, nil, 'n' )
	end
	
	def str_to_regexp_a( str )
		return self.str_to_regexp( '\\A' << str.to_s )
	end
	
	def str_to_regexp_az( str )
		return self.str_to_regexp( '\\A' << str.to_s << '\\z' )
	end
	
end
end






module DialplanPatternMatcher
module Logger
	
	def self.log( method = :info, message )
		self.logger.send( method, message )
	end
	
	def self.debug( message ); self.log( :debug , message ); end
	def self.info(  message ); self.log( :info  , message ); end
	def self.warn(  message ); self.log( :warn  , message ); end
	def self.error( message ); self.log( :error , message ); end
	def self.fatal( message ); self.log( :fatal , message ); end
	
	protected
	
	@@logger = nil
	
	def self.logger
		if ! @@logger
			if ::Object.const_defined?( :Rails )
				@@logger = Rails.logger
			elsif $0.match( /\b(?: rake )\b/x )
				require 'logger'
				@@logger = ::Logger.new( STDERR )
				@@logger.formatter = proc { | severity, time, progname, msg |
					#"%s: [%s] %s\n" % [ time.strftime('%Y-%m-%d %H:%M:%S %z'), severity, msg ]
					"DPM: [\033[1;32m%s\033[0m] \033[1m%s\033[0m\n" % [ severity, msg ]
				} if @@logger.respond_to?(:formatter)
			else
				require 'logger'
				@@logger = ::Logger.new( nil )
			end
		end
		return @@logger
	end
	
end
end



# Implement auto-loading via const_missing() so matchers that sub-class
# other matchers don't have to require that file themselves:

#require 'active_support'
#require 'active_support/dependencies'

module DialplanPatternMatcher
module Matchers
		
	protected
	
	@@use_active_support_autoloading = false
	if (Object.const_defined?( :ActiveSupport ) \
	&&  ActiveSupport.const_defined?( :Dependencies ) \
	)
		@@use_active_support_autoloading = true
		include ActiveSupport
		my_load_paths = [
			'.',
			#'config',
		]
		if    Dependencies.respond_to?( :autoload_paths )
			my_load_paths.each { |path|
				Dependencies.autoload_paths << File.join( File.dirname(__FILE__), path )
				Dependencies.autoload_once_paths.delete( path )
			}
		elsif Dependencies.respond_to?( :load_paths )  # deprecated
			my_load_paths.each { |path|
				Dependencies.load_paths << File.join( File.dirname(__FILE__), path )
				Dependencies.load_once_paths.delete( path )
			}
		else
			raise "Your ActiveSupport::Dependencies doesn't respond to :autoload_paths or :load_paths."
		end
	end
	
	def self.const_missing( name )
		Logger.debug( "Auto-loading class %s ..." % [ "#{self.to_s}::#{name}" ] )
		
		super if @@use_active_support_autoloading
		
		@@looked_for ||= {}
		raise ::NameError.new( "Class not found: #{name}" ) if @@looked_for[name]
		@@looked_for[name] = true
		
		#file = 'dialplan_pattern_matcher/matchers/' << DialplanPatternMatcher::Utils.class_name_to_file_basename( name )
		file = DialplanPatternMatcher::Utils.class_name_to_file_basename( "#{self.to_s}::#{name}" )
		begin
			#ActiveSupport::Dependencies::require_or_load( file )
			require file
		rescue ::LoadError => e
			raise e
		end
		
		klass = const_get(name)
		return klass if klass
		
		raise ::NameError.new( "Class not found: #{name}" )
	end
	
	

end
end



# Load all matchers so they can register themselves:

Dir[ File.dirname(__FILE__) + '/dialplan_pattern_matcher/matchers/*.rb' ].each { |file|
	f = File.basename( file, File.extname( file ))
	DialplanPatternMatcher::Logger.debug( "Loading %s ..." % [ ('matchers/' << f).inspect ] )
	require 'dialplan_pattern_matcher/matchers/' << f
}

DialplanPatternMatcher::PatternTypeRegistry.register_pattern_types()




=begin
t0 = Time.now
x = DialplanPatternMatcher::Matchers::MegacoDigitStringModified.new( "foo", "NXX." )
10000.times {
	x = DialplanPatternMatcher::Matchers::MegacoDigitStringModified.new( "foo", "NXX." )
}
t1 = Time.now
puts "                             took #{ t1 - t0 }"
puts "===> #{x.inspect}"
puts "===> #{x.to_s}"

marshalled = Marshal.dump( x )
puts "===> #{marshalled.inspect}"
t0 = Time.now
x2 = Marshal.load( marshalled )
10000.times {
	x2 = Marshal.load( marshalled )
}
t1 = Time.now
puts "                             took #{ t1 - t0 }"
puts "===> #{x2.inspect}"
puts "===> #{x2.to_s}"
=end


=begin
x = DialplanPatternMatcher::Matchers::MegacoDigitStringModified.new( "foo", "NXX." )
puts "===> #{x.inspect}"
puts "===> #{x.to_s}"

marshalled = Marshal.dump( x )
puts "===> #{marshalled.inspect}"
x2 = Marshal.load( marshalled )
puts "===> #{x2.inspect}"
puts "===> #{x2.to_s}"
=end


