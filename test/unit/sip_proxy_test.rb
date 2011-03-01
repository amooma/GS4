require 'test_helper'

class SipProxyTest < ActiveSupport::TestCase
  
  should "be valid build" do
    assert Factory.build(:sip_proxy).valid?
  end
  
  should "not be valid with .new" do
    assert ! SipProxy.new.valid?
  end
  
  
  # valid host
  [
    'hostname',
    '10.0.0.1',
  ].each { |name|
    should "be valid with host #{name.inspect}" do
      assert Factory.build( :sip_proxy, :name => name ).valid?
    end
  }
  
  # invalid host
  [
    nil,
    '',
    '-',
  ].each { |name|
    should "not be valid with host #{name.inspect}" do
      assert ! Factory.build( :sip_proxy, :name => name ).valid?
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
      assert Factory.build( :sip_proxy, :config_port => port ).valid?
    end
  }
  
  # invalid config_port
  [
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with config_port #{port.inspect}" do
      assert ! Factory.build( :sip_proxy, :config_port => port ).valid?
    end
  }
  
  
  should "not be valid when name not unique" do
    sip_proxy = Factory.create(:sip_proxy)
    assert ! Factory.build( :sip_proxy, :name => sip_proxy.name ).valid?
  end
  
end
