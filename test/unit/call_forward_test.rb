require 'test_helper'

class CallForwardTest < ActiveSupport::TestCase
	should "have a valid factory" do
		assert Factory.build(:call_forward).valid?
	end
	
	# destinations
	[
		'12345',
		'abcde',
		'ABCDE',
	].each { |destination|
		should "be possible to set destination to #{destination.inspect}" do
			assert Factory.build( :call_forward, :destination => destination ).valid?
		end
	}
	
	call_forward_reason = Factory.build( :call_forward_reason, :value => 'noanswer' )
	# reason "noanswer" and timeout
	[
		1,
		60,
		120,
		121,
	].each { |timeout|
		should "be possible to set timeout to #{timeout.inspect}" do
			assert Factory.build( :call_forward, :call_timeout => timeout, :call_forward_reason =>  call_forward_reason).valid?
		end
	}

end
