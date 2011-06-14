require 'test_helper'

class PhoneModelKeyTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:phone_model_key).valid?
  end
  
  should "not allow two phone_model_keys with the same name and the same phone_model_id" do
    phone_model = Factory.create(:phone_model)
    phone_model.phone_model_keys.create(:name => 'F1')
    
    assert !phone_model.phone_model_keys.build(:name => 'F1').valid?
  end
  
  should "allow two phone_model_keys with different names and the same phone_model_id" do
    phone_model = Factory.create(:phone_model)
    phone_model.phone_model_keys.create(:name => 'F1')
    
    assert phone_model.phone_model_keys.build(:name => 'F2').valid?
  end
  
end
