require 'test_helper'

class ProvisioningServerTest < ActiveSupport::TestCase
  
  should "be valid build" do
    assert Factory.build(:provisioning_server).valid?
  end
  
  should "not be valid with .new" do
    assert ! ProvisioningServer.new.valid?
  end
  
  
  # valid host
  [
    'hostname',
    '10.5.5.88',
  ].each { |host|
    should "be valid with host #{host.inspect}" do
      assert Factory.build( :provisioning_server, :name => host ).valid?
    end
  }
  
  # invalid host
  [
    nil,
    '',
    '-',
  ].each { |host|
    should "not be valid with host #{host.inspect}" do
      assert ! Factory.build( :provisioning_server, :name => host ).valid?
    end
  }
  
  
  # valid port
  [
    1,
    65535,
  ].each { |port|
    should "be valid with port #{port.inspect}" do
      assert Factory.build( :provisioning_server, :port => port ).valid?
    end
  }
  
  # invalid port
  [
    nil,
    '',
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with port #{port.inspect}" do
      assert ! Factory.build( :provisioning_server, :port => port ).valid?
    end
  }
  
  
  should "not be valid when name not unique" do
    provisioning_server = Factory.create(:provisioning_server)
    assert ! Factory.build( :provisioning_server, :name => provisioning_server.name ).valid?
  end
  
end
