#require File.expand_path( '../test_helper', __FILE__ )
require 'test_helper'
require 'active_support/backtrace_cleaner'


class DialplanPatternMatcherTest < ::ActiveSupport::TestCase
	
	test( "abstract matcher does not match" ) {
		dpp = DialplanPatternMatcher::Matchers::Pattern.new( '123' )
		match_result = dpp.match( '123' )
		assert_equal( false, match_result )
	}
	
	test( "no pattern class for unknown pattern type" ) {
		klass = DialplanPatternMatcher.pattern_class_for_type( :no_such_pattern_type )
		assert_equal( nil, klass )
	}
	
	test( "no pattern matcher for unknown pattern type" ) {
		dpp = DialplanPatternMatcher.pattern( :no_such_pattern_type, 'irrelevant' )
		assert_equal( nil, dpp )
		
		dpp = DPP( :no_such_pattern_type, 'irrelevant' )
		assert_equal( nil, dpp )
	}
	
	
	
	[
		:megaco_digitstring_mod,
	].each { |type|
		test( "pattern matcher for pattern type #{type.to_s.inspect}" ) {
			dpp = DialplanPatternMatcher.pattern( type, '123' )
			assert_not_equal( nil, dpp )
			
			dpp = DPP( type, '123' )
			assert_not_equal( nil, dpp )
		}
	}
	
	
	# Test valid and invalid Megaco patterns.
	# For valid Megaco patterns also check that they are compiled to the regexp we expect.
	{
		'123' => '123',
		'1(2)3' => false,
		'12x' => '12[0-9]',
		'1x2' => '1[0-9]2',
		'x' => '[0-9]',
		'[x]' => false,
		'' => false,
		'[]' => true,  # strange. specification unclear.
		'+1' => '[+]1',
		'+' => '[+]',
		'1+' => false,
		'1+2' => false,
		'1[+]2' => false,
		'12.' => '12*',
		'1[2-4].' => '1[2-4]*',
		'1x.' => '1[0-9]*',
		'1*.' => '1\\**',
		'1[ef].' => '1[*#]*',
		'1.2' => false,
		'.' => false,
		'..' => false,
		'2..' => false,
		'*12' => '\\*12',
		'#12' => '#12',
		'2**' => '2\\*\\*',
		'2:' => false,
		'2?' => false,
		'2!' => false,
		'1|2' => false,
		nil => false,
		'aBcD' => '[Aa][Bb][Cc][Dd]',
		'e1F2' => '\\*1#2',
		'*1#2' => '\\*1#2',
		'*.' => '\\**',
		'-' => false,
		'-2' => false,
		'1-2' => false,
		'2[3]9' => '2[3]9',
		'2[[9' => false,
		'2]]9' => false,
		'2][9' => false,
		'2[[]]9' => false,
		'2[]9' => '29',
		'2[34]9' => '2[34]9',
		'2[3-5]9' => '2[3-5]9',
		'2[3].' => '2[3]*',
		'2[].' => false,  # repetition after empty char class. specification unclear. could mean /2*/ or /2()*/.
		'[].' => false,  # specification unclear.
		'2[35-8]9' => '2[35-8]9',
		'2[AbCd]' => '2[AaBbCcDd]',
		'2[aBcD]' => '2[AaBbCcDd]',
		'2[g]' => false,
		'2[G]' => false,
		'2[l]' => false,
		'2[L]' => false,
		'2[s]' => false,
		'2[S]' => false,
		'2[t]' => false,
		'2[T]' => false,
		'2[z]' => false,
		'2[Z]' => false,
		'2[33]' => '2[33]',
		'2[A-C]' => false,
		'2[a-c]' => false,
		'2[a-C]' => false,
		'2[A-c]' => false,
		'2[3-C]' => false,
		'2[A-F]' => false,
		'2AB' => '2[Aa][Bb]',
		'2[A][B]' => '2[Aa][Bb]',
		'2ef' => '2\\*#',
		'2[ef]' => '2[*#]',
		'2e[e]e[e]e' => '2\\*[*]\\*[*]\\*',
		'2e[AeAe]A' => '2\\*[A*Aa*][Aa]',
		'2e[eAeA]A' => '2\\*[*A*Aa][Aa]',
		'2e[AeA]A' => '2\\*[A*Aa][Aa]',
		'2e[A]A' => '2\\*[Aa][Aa]',
		'2e[eAeAe]A' => '2\\*[*A*Aa*][Aa]',
		'2e[eAeAeAe]A' => '2\\*[*A*A*Aa*][Aa]',
		'2[*#]' => false,
		'2[3-]' => false,
		'2[3-4-]' => false,
		'2[-4]' => false,
		'2[3-3]' => '2[3-3]',
		'2[5-3]' => false,
	}.each { |pat, should_be_valid|
		if should_be_valid
			test( "pattern #{pat.inspect} should be valid" ) {
				assert_nothing_raised {
					dpp = DPP( :megaco_digitstring_mod, pat )
				}
			}
			if should_be_valid.class == String
				# should_be_valid is the expected regexp
				expected_regexp_source = should_be_valid
				test( "pattern #{pat.inspect} should be compiled to regexp #{expected_regexp_source}" ) {
					dpp = DPP( :megaco_digitstring_mod, pat )
					assert_equal( '\\A' << expected_regexp_source << '\\z', dpp.to_regexp.source )
				}
			end
		else
			test( "pattern #{pat.inspect} should not be valid" ) {
				assert_raise( ::DialplanPatternMatcher::DialplanPatternInvalidError ) {
					dpp = DPP( :megaco_digitstring_mod, pat )
				}
			}
		end
	}
	
	
	# Test if dialstrings match against patterns.
	{
		'12x' => {
			'120' => true,
			'121' => true,
			'12' => false,
			'' => false,
			'1200' => false,
			'130' => false,
			'12a' => false,
			'12A' => false,
			'12*' => false,
			'12#' => false,
			'12x' => false,
			'12X' => false,
		},
		'123' => {
			'123' => true,
			'456' => false,
			'1234' => false,
			'0123' => false,
		},
		'2[4-6]8' => {
			'248' => true,
			'258' => true,
			'268' => true,
			'278' => false,
			'27a' => false,
			'27A' => false,
		},
		'2[]9' => {
			'29' => true,
		},
		'2[3-3]' => {
			'23' => true,
		},
		'12[]' => {
			'12' => true,
		},
		'[]34' => {
			'34' => true,
		},
		'[]' => {
			'34' => false,
			'' => true,  # matches against an empty dialstring. strange but correct.
		},
		'+49' => {
			'+49' => true,
			'0049' => false,
		},
		'0049' => {
			'0049' => true,
			'+49' => false,
		},
		'0261[2-9]x.' => {
			'0261' => false,
			'02611' => false,
			'026112' => false,
			'02612' => true,
			'026123' => true,
			'0261234' => true,
		},
		'12.' => {
			'12' => true,
			'122' => true,
			'1222' => true,
			'1232' => false,
			'1233' => false,
		},
		'5*.' => {
			'5' => true,
			'5*' => true,
			'5**' => true,
			'5***' => true,
			'5**1' => false,
			'55' => false,
		},
		'1ef.' => {
			'1ef' => false,
			'1EF' => false,
			'1*#' => true,
			'1*' => true,
			'1*##' => true,
		},
		'1EF.' => {
			'1ef' => false,
			'1EF' => false,
			'1*#' => true,
			'1*' => true,
			'1*##' => true,
		},
		'1[e][f].' => {
			'1ef' => false,
			'1EF' => false,
			'1*#' => true,
			'1*' => true,
			'1*##' => true,
		},
		'*12' => {
			'*12' => true,
		},
		'[aBcD].' => {
			'bbb' => true,
			'BBB' => true,
			'BbB' => true,
			'bBb' => true,
			'bcc' => true,
			'bCC' => true,
			'bbc' => true,
			'bbC' => true,
		},
		'aBcD' => {
			'aBcD' => true,
			'AbCd' => true,
		},
		'B.' => {
			'B' => true,
			'b' => true,
			'BB' => true,
			'bb' => true,
			'BBb' => true,
			'bBb' => true,
		},
	}.each { |pat, tests| tests.each { |dial_string, should_match|
		test( "pattern #{pat.inspect} #{should_match ? "matches" : "does not match"} dial string #{dial_string.inspect}" ) {
			dpp = DPP( :megaco_digitstring_mod, pat )
			assert_equal( should_match, dpp.match( dial_string ))
		}
	}}
	
	
end
