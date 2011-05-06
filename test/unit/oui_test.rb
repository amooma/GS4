require 'test_helper'

class OuiTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:oui).valid?
  end

  # oui has to have an existing manufacturer
  #
  should "have an existing manufacturer" do
    oui = Factory.build(:oui)
    Manufacturer.where(:id => oui.manufacturer_id).destroy_all
    assert !oui.valid?
  end

  # An oui value must be unique
  #
  should "not be valid with a not unique value" do
    oui = Factory.create(:oui)
    assert !Factory.build(:oui, :value => oui.value).valid?
  end

  # these values should not validate
  #
  [
    'AABBII',
    'abcdeG',
    'abcdef',
    '123aaa',
    'AA00BB0',
    '00AAB'
  ].each { |value|
    should "not be possible to set value to \"#{value}\"" do
      assert !Factory.build( :oui, :value => value ).valid?
    end
  }

  # these values should validate
  #
  [
    'AABBCC',
    '012345',
    'AA1234'
  ].each { |value|
    should "be possible to set value to \"#{value}\"" do
      assert Factory.build( :oui, :value => value ).valid?
    end
  }
end
