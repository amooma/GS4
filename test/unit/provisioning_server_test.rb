require 'test_helper'

class ProvisioningServerTest < ActiveSupport::TestCase
  should "be valid build" do
    assert Factory.build(:provisioning_server).valid?
  end
  should "not be valid with .new" do
    assert !ProvisioningServer.new.valid?
  end
  should "not be valid with nil name" do
    assert !Factory.build(:provisioning_server, :name => nil).valid?
  end
  should "not be valid when name not unique" do
    provisioning_server = Factory.create(:provisioning_server)
    assert !Factory.build(:provisioning_server, :name => provisioning_server.name).valid?
  end 
end
