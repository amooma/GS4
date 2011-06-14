require 'test_helper'

class PhoneKeyToFunctionMappingTest < ActiveSupport::TestCase
  
  should "be valid" do
    assert Factory.build( :phone_key_to_function_mapping ).valid?
  end
  
  
  # invalid phone_model_key_id
  [
    nil,
    -1,
    'foo',
  ].each { |x|
    should "not allow phone_model_key_id to be set to #{x.inspect}" do
      assert ! Factory.build( :phone_key_to_function_mapping, :phone_model_key_id => x ).valid?
    end
  }
  
  # invalid phone_key_function_definition_id
  [
    nil,
    -1,
    'foo',
  ].each { |x|
    should "not allow phone_key_function_definition_id to be set to #{x.inspect}" do
      assert ! Factory.build( :phone_key_to_function_mapping, :phone_key_function_definition_id => x ).valid?
    end
  }
  
  
end
