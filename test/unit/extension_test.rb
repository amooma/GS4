require 'test_helper'

class ExtensionTest < ActiveSupport::TestCase
  
  should "have a valid factory" do
    assert Factory.build(:extension).valid?
  end
  
end
