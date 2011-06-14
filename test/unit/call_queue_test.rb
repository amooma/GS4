require 'test_helper'

class CallQueueTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:call_queue).valid?
	end
	
end
