require 'test_helper'

class ProvisioningLogEntryTest < ActiveSupport::TestCase
  
  
  [
    "Test message",
    "",
    nil,
  ].each { |memo|
    should "allow #{memo.inspect} as memo" do
      assert Factory.build( :provisioning_log_entry, :memo => memo ).valid?
    end
  }
  
  
  [
    true,
    false,
  ].each { |succeeded|
    should "allow #{succeeded.inspect} as succeeded" do
      assert Factory.build( :provisioning_log_entry, :succeeded => succeeded ).valid?
    end
  }
  
  
end
