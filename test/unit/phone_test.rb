require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  should "be valid" do
    assert Factory.build(:phone).valid?
  end

  # Test a wrong oui start of the mac address
  #
  should "not allow an invalid start of the MAC address (OUI has to be right)" do
    phone = Factory.build(:phone)
    phone.mac_address = "000000010203"
    assert !phone.valid?
  end

  # Test invalid mac addresses
  #
  [
    nil,
    '007',
    'AAFF0011',
    '1122334455GG',
    '112233aabbcc11',
    'not_a_valid_MAC_address'
  ].each do |invalid_mac_address|
    should "not allow #{invalid_mac_address} as an mac_address" do
      phone = Factory.build(:phone)
      phone.mac_address = invalid_mac_address
      assert !phone.valid?
    end
  end
  
  # Test valid mac addresses
  #
  [
    ":aa:bb:cc",
    ":AA:BB:cc",
    "AABBcc",
    "-33-44-55"
  ].each do |valid_end_of_a_mac_address|
    should "allow #{valid_end_of_a_mac_address} being the last part of a mac_address" do
      phone = Factory.build(:phone)
      separator = valid_end_of_a_mac_address.gsub(/[0-1A-Za-z]/,'')[0]
      phone.mac_address = phone.mac_address.slice(0,6).scan(/../).join(separator) + valid_end_of_a_mac_address
      assert phone.valid?
    end
  end
  
  # test uniqueness of the mac_address
  #
  should "not be possible to create a second phone with the same mac address" do
    phone = Factory.create(:phone)
    assert !Phone.create(:mac_address => phone.mac_address, :phone_model_id => phone.phone_model_id).valid?
  end
  
  # Test invalid ip addresses
  [
    '1.2.3.',
    '1.2.3.256',
    '010.000.00.005',
    '1.1.1.',
    'asfd',
    '112233AABBcc'
  ].each do |invalid_ip_address|
    should "not allow #{invalid_ip_address} as an ip_address" do
      assert !Factory.build(:phone, :ip_address => invalid_ip_address).valid?
    end
  end
  
  # Test valid ip addresses
  [
    '1.2.3.4',
    '255.255.255.255',
    '123.123.123.123',
    '1.10.100.250',
    '',
    nil,
  ].each do |valid_ip_address|
    should "allow #{valid_ip_address} as an ip_address" do
      assert Factory.build(:phone, :ip_address => valid_ip_address).valid?
    end
  end
  
  # ip_address has to be unique
  #
  should "not be valid" do
    phone = Factory.create(:phone)
    assert !Factory.build(:phone, :ip_address => phone.ip_address).valid?
  end
  
  should "be OK to create 2 phones with different IP addresses" do
    phone = Factory.create( :phone, :ip_address => '2.3.4.5' )
    assert  Factory.build(  :phone, :ip_address => '2.3.4.6' ).valid?
  end
  
  should "be OK to create 2 phones with the IP address set to ''" do
    phone = Factory.create( :phone, :ip_address => '' )
    assert  Factory.build(  :phone, :ip_address => '' ).valid?
  end
  
  should "be OK to create 2 phones with the IP address set to nil" do
    phone = Factory.create( :phone, :ip_address => nil )
    assert  Factory.build(  :phone, :ip_address => nil ).valid?
  end
  
  
  # Test invalid phone model
  [
    -1,
  ].each do |phone_model_id|
    should "not allow #{phone_model_id.inspect} as a phone_model_id" do
      phone = Factory.create(:phone)
      phone.phone_model_id = phone_model_id
      assert !phone.valid?
    end
  end
  
  # Test if Phone has a log_provisioning() instance method.
  should "have a \"log_provisioning\" instance method" do
    assert Phone.new().respond_to?( :log_provisioning )
  end
  
  
  should "automatically store the previous ip_address in last_ip_address" do
    phone = Factory.create( :phone, :ip_address => '10.0.0.55' )
    assert phone.last_ip_address == nil
    
    phone.ip_address = '10.0.0.2'
    phone.save
    assert phone.last_ip_address == '10.0.0.55'
    
    phone.ip_address = '10.0.0.111'
    phone.save
    assert phone.last_ip_address == '10.0.0.2'
  end
  
  
  # check a full setup
  #
  should "have all bells and whistles" do
    phone = Factory.create(:phone)
    manufacturer = phone.phone_model.manufacturer
    oui = manufacturer.ouis.first
    phone_model = phone.phone_model
    
    # Create some codecs and some keys
    #
    phone_model.update_attributes({:max_number_of_sip_accounts => 3})
    phone_model.codecs << Factory.create(:codec)
    phone_model.codecs << Factory.create(:codec)
    phone_model.codecs << Factory.create(:codec)
    phone_model.codecs << Factory.create(:codec)
    phone_model.codecs << Factory.create(:codec)
  
    PhoneKeyFunctionDefinition.create([
      { :name => 'BLF'              , :type_of_class => 'string'  , :regex_validation => nil },
      { :name => 'Speed dial'       , :type_of_class => 'string'  , :regex_validation => nil },
      { :name => 'ActionURL'        , :type_of_class => 'url'     , :regex_validation => nil },
      { :name => 'Line'             , :type_of_class => 'integer' , :regex_validation => nil }
    ])  
    
    (1..10).each do |key_number|
      phone_model_key = phone_model.phone_model_keys.create(:name => "F#{key_number}")
      phone_model_key.phone_key_function_definitions << PhoneKeyFunctionDefinition.all
    end
    
    phone = Factory.create(:phone, :phone_model_id => phone_model.id)
    Factory.create(:sip_account, :phone_id => phone.id)
    Factory.create(:sip_account, :phone_id => phone.id)
    Factory.create(:sip_account, :phone_id => phone.id)
    
#    (0 .. 2).each do |i|
#      (0 .. i).each do |codec_i|
#        phone.sip_accounts[i].codecs << phone_model.codecs[codec_i]
#      end
#    end
  
    first_sip_account = phone.sip_accounts.first
    
    # Lets create a BLF 42 on the first key at the first sip_account
    #f1 = first_sip_account.phone_keys.create
    #f1.phone_model_key_id = phone_model.phone_model_keys.first.id
    #f1.phone_key_function_definition_id = phone_model.phone_model_keys.first.phone_key_function_definitions.first.id
    #f1.value = "42"
    #f1.save
  
    assert phone_model.codecs.size == 5    
    assert phone.sip_accounts.size == 3
    #assert phone.sip_accounts.first.codecs.count == 1
    #assert phone.sip_accounts.last.codecs.count == 3
    #assert f1.valid?
    assert first_sip_account.valid?
  end
  
end
