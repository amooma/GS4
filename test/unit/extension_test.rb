require 'test_helper'

class ExtensionTest < ActiveSupport::TestCase
  should "be valid build" do
    assert Factory.build(:extension).valid?
  end
end
