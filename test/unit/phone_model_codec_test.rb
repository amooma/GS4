require 'test_helper'

class PhoneModelCodecTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:phone_model_codec).valid?
  end
  
  # A codec must be unique
  #
  should "not be valid with a not unique name" do
    phone_model = Factory.create(:phone_model)
    codec1 = Factory.create(:codec)
    codec2 = Factory.create(:codec)
    phone_model.codecs << codec1
    phone_model.codecs << codec2
    assert !phone_model.codecs.build(Factory.attributes_for(:codec, :name => codec1.name)).valid?
  end
  
end
