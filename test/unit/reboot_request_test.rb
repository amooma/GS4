require 'test_helper'

class RebootRequestTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:reboot_request).valid?
  end
end
