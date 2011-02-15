require 'test_helper'

class SipServerTest < ActiveSupport::TestCase
  should "be valid build" do
    assert Factory.build(:sip_server).valid?
  end
  should "not be valid with .new" do
    assert !SipServer.new.valid?
  end
  should "not be valid with nil name" do
    assert !Factory.build(:sip_server, :name => nil).valid?
  end
  should "not be valid when name not unique" do
    sip_server = Factory.create(:sip_server)
    assert !Factory.build(:sip_server, :name => sip_server.name).valid?
  end 
end
