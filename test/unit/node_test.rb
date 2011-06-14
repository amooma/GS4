require 'test_helper'

class NodeTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:node).valid?
	end
	
end
