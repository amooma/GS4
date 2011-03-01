require 'test_helper'

class SipServerTest < ActiveSupport::TestCase
  
  should "be valid build" do
    assert Factory.build(:sip_server).valid?
  end
  
  should "not be valid with .new" do
    assert ! SipServer.new.valid?
  end
  
  
  # valid host
  [
    'hostname',
    '10.0.0.1',
  ].each { |host|
    should "be valid with host #{host.inspect}" do
      assert Factory.build( :sip_server, :name => host ).valid?
    end
  }
  
  # invalid host
  [
    nil,
    '',
    '-',
  ].each { |host|
    should "not be valid with host #{host.inspect}" do
      assert ! Factory.build( :sip_server, :name => host ).valid?
    end
  }
  
  
  # valid config_port
  [
    '',
    nil,
    1,
    65535,
  ].each { |port|
    should "be valid with config_port #{port.inspect}" do
      assert Factory.build( :sip_server, :config_port => port ).valid?
    end
  }
  
  # invalid config_port
  [
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with config_port #{port.inspect}" do
      assert ! Factory.build( :sip_server, :config_port => port ).valid?
    end
  }
  
  
  should "not be valid when name not unique" do
    sip_server = Factory.create(:sip_server)
    assert ! Factory.build( :sip_server, :name => sip_server.name ).valid?
  end
  
end
