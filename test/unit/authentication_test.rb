require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  should "be valid build" do
    assert Factory.build(:authentication).valid?
  end
  should "not be valid with nil provider" do
    assert ! Factory.build(:authentication, :provider => nil).valid?
  end
  should "not be valid with nil uid" do
    assert ! Factory.build(:authentication, :uid => nil).valid?
  end
end
