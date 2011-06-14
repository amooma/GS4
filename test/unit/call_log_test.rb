require 'test_helper'

class CallLogTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:call_log).valid?
	end
	
end
