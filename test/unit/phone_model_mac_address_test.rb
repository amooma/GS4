require 'test_helper'

class PhoneModelMacAddressTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:phone_model_mac_address).valid?
  end
end
