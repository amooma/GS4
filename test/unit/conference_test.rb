require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:conference).valid?
	end
	
end
