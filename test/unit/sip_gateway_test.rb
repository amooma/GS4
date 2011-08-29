require 'test_helper'

class SipGatewayTest < ActiveSupport::TestCase
	
	should "have a valid factory" do
		assert Factory.build(:sip_gateway).valid?
	end
	
end
