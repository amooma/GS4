require 'test_helper'

class CallForwardReasonsTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:call_forward_reason).valid?
	end
	
	[
		'busy',
		'noanswer',
		'offline',
		'always',
		'assistant'
	].each { |value|
		should "be possible to use #{value.inspect} as value" do
		assert Factory.build( :call_forward_reason, :value => value ).valid?
		end
	}
end
