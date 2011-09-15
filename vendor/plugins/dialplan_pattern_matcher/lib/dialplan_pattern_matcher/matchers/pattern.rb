
module DialplanPatternMatcher::Matchers
	
	# The abstract pattern type class.
	#
	class Pattern
		
		include DialplanPatternMatcher::MatcherHelpers
		
		def self.pattern_type
			return nil
		end
		
		# A prefix (if any) to display that is automatically prepended to the pattern.
		# E.g. '^' for an anchored regexp-style pattern class or
		# '_' for an Asterisk-style pattern class.
		def self.display_auto_prefix
			return ''
		end
		
		# A suffix (if any) to display that is automatically appended to the pattern.
		# E.g. '$' for an anchored regexp-style pattern.
		def self.display_auto_suffix
			return ''
		end
		
		
		@pattern = nil
		
		def initialize( pattern )
			@pattern  = pattern
		end
		
		def match( dialstring )
			return false
		end
		
		def pattern
			return @pattern
		end
		
		def to_s
			return "#<#{self.class.to_s.demodulize} @type=#{@type.inspect}, @pattern=#{@pattern.inspect}>"
		end
		
		def marshal_dump
			return [ @type, @pattern ]
		end
		
		def marshal_load( obj )
			initialize( *obj )
		end
		
		#def _dump level
		#	[ @type, @pattern ].join(':')
		#end
		#
		#def self._load args
		#	new(*args.split(':'))
		#end
		
		protected
		
		# Called by sub-classes to register themselves for a specific pattern type.
		#def self.register_pattern_type
		#	DialplanPatternMatcher::PatternTypeRegistry.register_pattern_type( self::TYPE, self )
		#end
		
		# Callback invoked whenever a sub-class of the current class is created.
		def self.inherited( subclass )
			# Note: The subclass isn't fully defined yet in the way that
			# you may expect, i.e. it doesn't have constants or methods,
			# so we can't use subclass.pattern_type yet.
			
			DialplanPatternMatcher::PatternTypeRegistry.register_pattern_class( subclass )
			super
		end
		
		# Helper method for sub-classes that convert the pattern to
		# a Regexp and store it in the @regexp class variable.
		def regexp_match( dialstring )
			return !! @regexp.match( dialstring.to_s )
		end
				
	end
end
