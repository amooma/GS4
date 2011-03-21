require 'test_helper'

class SipPhoneTest < ActiveSupport::TestCase
  # testing sip_phone requires provisioning_server to be accessible
  
  should "not be valid without a phone_id if it has a provisioning_server_id" do
    assert ! Factory.build( :sip_phone, :phone_id => nil ).valid?
  end
  
  should "be valid with a phone_id if it has a provisioning_server_id" do
    assert Factory.build( :sip_phone, :phone_id => 99999 ).valid?
  end
  
  should "not be valid without a provisioning_server_id" do
    assert ! SipPhone.new( :provisioning_server_id => nil, :phone_id => nil ).valid?
  end
  
end
