require 'test_helper'

class ExtensionTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:extension).valid?
	end
	
	
	# valid extension
	[
		'123',
		'1',
		'123456',
		'foo',
		'12345678901',
		'123foo',
		'012foo',
		'01',
		'foo123',
		'hans.test',
	#	'-',
		'+',
	#	'-1',
	#	'-0',
		'+10',
		'azAZ09+*.-_',
		'*1',
	].each { |value|
		should "be valid with extension #{value.inspect}" do
			e = Factory.build( :extension, :extension => value )
			assert e.valid?
		end
		
		should "be valid with extension #{value.inspect} (and actually store it)" do
			e = Factory.build( :extension, :extension => value )
			# Check that the Extension actually stored the string
			# without casting it to an integer:
			assert e.extension == value
		end
	}
	
	# invalid extension
	[
		nil,
		'',
		-1,
		'-',
		'-1',
		'-0',
		'a#',
		'a<',
		'a>',
		'anonymous',
	].each { |value|
		should "not be valid with extension #{value.inspect}" do
			assert ! Factory.build( :extension, :extension => value ).valid?
		end
	}
	
	
	# valid destination
	[
		'123',
		'1',
		'123456',
		'foo',
		'12345678901',
		'123foo',
		'012foo',
		'01',
		'foo123',
		'hans.test',
		'-',
		'+',
		'-1',
		'-0',
		'+10',
		'azAZ09+*.-_',
		'*1',
	].each { |value|
		should "be valid with destination #{value.inspect}" do
			e = Factory.build( :extension, :destination => value )
			assert e.valid?
		end
		
		should "be valid with value #{value.inspect} (and actually store it)" do
			e = Factory.build( :extension, :destination => value )
			# Check that the Extension actually stored the string
			# without casting it to an integer:
			assert e.destination == value
		end
	}
	
	# invalid destination
	[
		nil,
		'',
		
		'a#',
		'a<',
		'a>',
		'anonymous',
	].each { |value|
		should "not be valid with destination #{value.inspect}" do
			assert ! Factory.build( :extension, :destination => value ).valid?
		end
	}
	
	
end
