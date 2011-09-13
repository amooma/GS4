#require 'dialplan_pattern_matcher/matchers/pattern'

module DialplanPatternMatcher::Matchers

	# Matcher for Megaco "+digitString+" patterns.
	#
	class MegacoDigitStringModified < Pattern
		
		def self.pattern_type
			return :megaco_digitstring_mod
		end
		
		def self.display_auto_prefix
			return ''
		end
		
		def self.display_auto_suffix
			return ''
		end
		
		
		@regexp = nil
		
		def initialize( pattern )
			super
			@regexp = pattern_to_regexp( @pattern )
			@pattern = self.display_normalize( @pattern )
			#DialplanPatternMatcher::Logger.debug "Compiled #{self.class.pattern_type} #{pattern.inspect} to #{@regexp.inspect}"
		end
		
		def pattern_to_regexp( pattern )
			self.validate!( pattern )
			pat = pattern.to_s.dup
			
			pat.gsub!( /(?i:  x   )/nx, '[0-9]' )
			
			pat.gsub!( /(?i: [e*] )/nx, '\\*' )
			pat.gsub!( /(?i: [f#] )/nx,  '#' )
			
			# Now we may have '[\\*]', which should be '[*]'. Fix that:
			pat2 = ''
			in_char_class = false
			pat.chars { |c|
				if    c == '['; in_char_class = true
				elsif c == ']'; in_char_class = false
				end
				pat2 << c if (! in_char_class || c != '\\')
			}
			pat = pat2
			
			pat.gsub!( /     [+]   /nx, '[+]' )
			pat.gsub!( /     [.]   /nx, '*' )
			pat.gsub!( /(?i: [TSLZ] )/nx, '' )
			pat.gsub!( /     \[\]  /nx, '' )  # empty char-class not valid in Regexp
			
			# Make letters A-D in character classes case-insensitive:
			pat.gsub!( / \[  ([^\]]*) (?<!-)[Aa]+(?!-) ([^\]]*)  \] /nx, '[\\1Aa\\2]' )
			pat.gsub!( / \[  ([^\]]*) (?<!-)[Bb]+(?!-) ([^\]]*)  \] /nx, '[\\1Bb\\2]' )
			pat.gsub!( / \[  ([^\]]*) (?<!-)[Cc]+(?!-) ([^\]]*)  \] /nx, '[\\1Cc\\2]' )
			pat.gsub!( / \[  ([^\]]*) (?<!-)[Dd]+(?!-) ([^\]]*)  \] /nx, '[\\1Dd\\2]' )
			
			# Make letters A-D case-insensitive outside of character classes:			
			pat2 = ''
			in_char_class = false
			pat.chars { |c|
				if    c == '['; in_char_class = true
				elsif c == ']'; in_char_class = false
				end
				if ! in_char_class && c.match( /\A [A-D] \z/ix )
					pat2 << '[' << c.upcase.to_s << c.downcase.to_s << ']'
				else
					pat2 << c
				end
			}
			pat = pat2
			
			begin
				return self.str_to_regexp_az( pat )
			rescue ::RegexpError => e
				raise( ::DialplanPatternMatcher::DialplanPatternInvalidError.new( "Invalid pattern %s: %s (%s)" % [ pattern.inspect, e.message, e.class.name ] ))
			end
		end
		
		def match( dialstring )
			#return !! @regexp.match( dialstring.to_s )
			return self.regexp_match( dialstring )
		end
		
		# Just in case anyone wants to use Regexp.try_convert() on this object.
		def to_regexp
			return @regexp
		end
		
		protected
		
		def valid?( pattern )
			regexp_valid_pattern = /\A(
				 (     ^[+]     )
				|(      [0-9]   )
				|((?i:  [A-D]  ))
				|((?i:  [E*F#] ))
				|((?<!^)[.]$    )
				|((?i:  [x]    ))
				|( \[ (
					 ( [0-9] - [0-9] )
					|((?i: [0-9A-DEF] ))
				)* \] )
			)+\z/nxo
			return false if ! regexp_valid_pattern.match( pattern.to_s )
			# Don't allow repetition after empty char class. Specification is unclear. Could mean /2*/ or /2()*/ :
			return false if /\[\]\./nxo.match( pattern.to_s )
			return true
		end
		
		def validate!( pattern )
			self.valid?( pattern ) ||
				raise( ::DialplanPatternMatcher::DialplanPatternInvalidError.new( "Invalid pattern %s" % [ pattern.inspect ] ))
		end
		
		def display_normalize( pattern )
			pat = pattern.to_s.dup
			pat.gsub!( /[A-D]/i  ) { |s| s.upcase   }
			pat.gsub!( /[ef]/i   ) { |s| s.downcase }
			pat.gsub!( /[e]/i    ) { |s| '*' }
			pat.gsub!( /[f]/i    ) { |s| '#' }
			pat.gsub!( /[x]/i    ) { |s| s.downcase }
			pat.gsub!( /[g-k]/i  ) { |s| s.downcase }
			pat.gsub!( /[TSLZ]/i ) { |s| s.upcase   }
			return pattern
		end
		
	end
end
