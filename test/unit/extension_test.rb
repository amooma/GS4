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

	should "Change the default length if it makes sense" do
	  Configuration.find_or_create_by_name('default_extension_length').
	                update_attributes(:value => '6')
	  Factory.create( :extension, :extension => 22 )
	  assert_equal(Configuration.get(:default_extension_length, 12, Integer), 2)
	  Factory.create( :extension, :extension => 111 )
	  assert_equal(Configuration.get(:default_extension_length, 12, Integer), 3)
	end

	should "guess the next free extension" do
	  Configuration.find_or_create_by_name('default_extension_length').
	                update_attributes(:value => '6')
	  assert_equal(Extension.next_unused_extension, 100000)
	  Factory.create( :extension, :extension => 22 )
	  assert_equal(Extension.next_unused_extension, 23)
	  Factory.create( :extension, :extension => 21 )
	  assert_equal(Extension.next_unused_extension, 23)
	end
	
	
end
