require 'test_helper'

class ManufacturerTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:manufacturer).valid?
  end
  
  # A manufacturer name must be unique
  #
  should "not be valid with a not unique name" do
    manufacturer = Factory.create(:manufacturer)
    assert !Factory.build(:manufacturer, :name => manufacturer.name).valid?
  end
  
  # A manufacturer has to have a name
  #
  should "not be valid with nil name" do
    manufacturer = Factory.create(:manufacturer)
    assert !Factory.build(:manufacturer, :name => nil).valid?
  end
  
  should "not be valid with an empty name" do
    manufacturer = Factory.create(:manufacturer)
    assert !Factory.build(:manufacturer, :name => '').valid?
  end
end
