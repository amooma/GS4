require 'test_helper'

class PhoneModelTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:phone_model).valid?
  end
  
  # nil is not a valid value
  #
  [
    'max_number_of_sip_accounts',
    'number_of_keys',
    'manufacturer_id'
  ].each do |field_name|
    should "not be ok to set #{field_name} to nil" do
      assert !Factory.build(:phone_model, field_name.to_sym => nil).valid?
    end
  end

  # -1 is not a valid value
  #
  [
    'max_number_of_sip_accounts',
    'number_of_keys',
    'manufacturer_id'
  ].each do |field_name|
    should "not be ok to set #{field_name} to -1" do
      assert !Factory.build(:phone_model, field_name.to_sym => -1).valid?
    end
  end
  
  # phone_model has to have a manufacturer
  #
  should "have a valid manufacturer" do
    phone_model = Factory.build(:phone_model)
    Manufacturer.where(:id => phone_model.manufacturer_id).destroy_all
    assert !phone_model.valid?
  end

  # find_by_mac_address(mac_address)
  #
  should "find a phone_model by a mac_address or a fragment" do
    phone_model_mac_address = Factory.create(:phone_model_mac_address)
    mac_address = phone_model_mac_address.starts_with
    mac_address = mac_address + 'A' if mac_address.length != 12
    assert PhoneModel.find_by_mac_address(mac_address) == phone_model_mac_address.phone_model
  end

  should "not find a phone_model by a too short mac_address fragment" do
    phone_model_mac_address = Factory.create(:phone_model_mac_address)
    mac_address = phone_model_mac_address.starts_with
    mac_address = mac_address[0,4]
    assert !(PhoneModel.find_by_mac_address(mac_address) == phone_model_mac_address.phone_model)
  end

  should "not find a phone_model by a too long mac_address fragment" do
    phone_model_mac_address = Factory.create(:phone_model_mac_address)
    mac_address = phone_model_mac_address.starts_with
    mac_address = mac_address + 'AAAAAAAAAAAAAAAA'
    assert !(PhoneModel.find_by_mac_address(mac_address) == phone_model_mac_address.phone_model)
  end
  
  
  # valid url
  [
    nil,
    '',
    'http://www.snom.com/de/produkte/ip-telefone/snom-370/',
    'http://user:pass@example.com/',
  ].each { |url|
    should "be ok to set url to #{url.inspect}" do
      assert Factory.build( :phone_model, :url => url ).valid?
    end
  }
  
  # invalid url
  [
    '##',
    '/de/produkte/ip-telefone/snom-370/',
    'http:www.snom.com/',
    'mailto:user@example.com',
    'foobar://example.com/',
  ].each { |url|
    should "not be ok to set url to #{url.inspect}" do
      assert ! Factory.build( :phone_model, :url => url ).valid?
    end
  }
  
  
  # valid name
  [
    'Foo',
    'Foo Model 123xy',
  ].each { |name|
    should "be ok to set name to #{name.inspect}" do
      assert Factory.build( :phone_model, :name => name ).valid?
    end
  }
  
  # invalid name
  [
    nil,
    '',
  ].each { |name|
    should "not be ok to set name to #{name.inspect}" do
      assert ! Factory.build( :phone_model, :name => name ).valid?
    end
  }
  
  
  # Test that reducing the max_number_of_sip_accounts will not create 
  # a state where there are phones with too many sip_accounts.
  should "not be ok to reduce the max_number_of_sip_accounts to a value below the value of already existing phones" do
    phone_model = Factory.create(:phone_model, :max_number_of_sip_accounts => 3)

    # create phones - each with a different amount of sip_accounts
    phones = Array.new
    (1 .. phone_model.max_number_of_sip_accounts).each do |i|
      phones[i] = Factory.create(:phone, :phone_model_id => phone_model.id)
      (1 .. i).each do |z|
        Factory.create(:sip_account, :phone_id => phones[i].id)
      end
    end

    phone_model.max_number_of_sip_accounts = 2
    assert !phone_model.valid?

    phone_model.max_number_of_sip_accounts = 3
    assert phone_model.valid?

    phone_model.max_number_of_sip_accounts = 4
    assert phone_model.valid?
  end

  # Test that reducing the number_of_keys will not create 
  # a state where there are more already existing phone_model_keys than number_of_keys in the database.
  should "not be ok to reduce the number_of_keys to a value below the number of already existing phone_model_keys" do
    # Create a phone_model with some codecs and some keys
    #
    phone_model = Factory.create(:phone_model, :number_of_keys => 10)

    PhoneKeyFunctionDefinition.create([
      { :name => 'BLF'              , :type_of_class => 'string'  , :regex_validation => nil },
      { :name => 'Speed dial'       , :type_of_class => 'string'  , :regex_validation => nil },
      { :name => 'ActionURL'        , :type_of_class => 'url'     , :regex_validation => nil },
      { :name => 'Line'             , :type_of_class => 'integer' , :regex_validation => nil }
    ])  
    
    (1..5).each do |key_number|
      phone_model_key = phone_model.phone_model_keys.create(:name => "F#{key_number}")
      phone_model_key.phone_key_function_definitions << PhoneKeyFunctionDefinition.all
    end
    
    phone_model.number_of_keys = 4
    assert !phone_model.valid?
    
    phone_model.number_of_keys = 5
    assert phone_model.valid?
    
    phone_model.number_of_keys = 6
    assert phone_model.valid?
  end
end
