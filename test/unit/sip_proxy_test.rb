require 'test_helper'

class SipProxyTest < ActiveSupport::TestCase
  should "be valid build" do
    assert Factory.build(:sip_proxy).valid?
  end
  should "not be valid with .new" do
    assert !SipProxy.new.valid?
  end
  should "not be valid with nil name" do
    assert !Factory.build(:sip_proxy, :name => nil).valid?
  end
  should "not be valid when name not unique" do
    sip_proxy = Factory.create(:sip_proxy)
    assert !Factory.build(:sip_proxy, :name => sip_proxy.name).valid?
  end 
end
