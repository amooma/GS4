require 'test_helper'

class SipAccountTest < ActiveSupport::TestCase
  # testing sip_account requires provisioning_server to be accessible
  
  
  # valid extension
  [
    '123',
    '1',
    '123456',
  ].each { |extension|
    should "be valid with extension #{extension.inspect}" do
      assert Factory.build( :sip_account, :phone_number => extension ).valid?
    end
  }
  
  # invalid extension
  [
    nil,
    '',
    'foo',
    '12345678901',
    '123foo',
    '012foo',
    'foo123',
  # '01',
    '-',
    '+',
    -1,
    '-1',
    '-0',
  # '+10',
  ].each { |extension|
    should "not be valid with extension #{extension.inspect}" do
      assert ! Factory.build( :sip_account, :phone_number => extension ).valid?
    end
  }
  
  # invalid auth_name
  #
  [
    '%A',
    '%XX',
    '%Ff',
  # "-A-\x00-B-",   #FIXME - ActiveRecord's SQLite adapter has a bug and does not escape \x00 bytes.
  # "\x00",         #FIXME - ActiveRecord's SQLite adapter has a bug and does not escape \x00 bytes."
    '\\',
    '"',
    'x' * 256,
  ].each { |username|
    should "not be possible to set auth_name to #{username.inspect}" do
      assert ! Factory.build( :sip_account, :auth_name => username ).valid?
    end
  }
  
  # valid auth_name
  #
  [
    'elvis',
    'Elvis123',
    '-_.!~*\'()',
    '%FF',
    '&=+$,;?/',
  ].each { |username|
    should "be possible to set auth_name to #{username.inspect}" do
      assert Factory.build( :sip_account, :auth_name => username ).valid?
    end
  }
  # valid password
  #
  [
    nil,
    '',
    'ABCabc012',
    '-_.!~*\'()',
    '&=+$,',
    '%00',
    '%20',
    '%FF',
  ].each { |password|
    should "be possible to set password to #{password.inspect}" do
      assert Factory.build( :sip_account, :password => password ).valid?
    end
  }
  
  # invalid password
  #
  [
    '%2',
    '%XX',
    '%ff',
    '%Ff',
    '%',
    '%%%',
    '"',
    ':',
    '#',
    '\\',
    'x' * 256,
  ].each { |password|
    should "not be possible to set password to #{password.inspect}" do
      assert ! Factory.build( :sip_account, :password => password ).valid?
    end
    
  }
  
  should "create a SIP account on the Cantina provisioning server" do
    puts ""
    
    
    #puts "-----------------------------------------------------------"
    #puts "Creating a User ..."
    #user = User.create(
    #  :username  => "test",
    #  :email     => "test@test.test",
    #  :password  => "123123123",
    #)
    #puts user.inspect
    #puts "Errors: #{user.errors.inspect}" if user.errors.length > 0
    #assert user.valid?
    
    
    puts "-----------------------------------------------------------"
    puts "Creating a SipServer without a config_port ..."
    sip_server = SipServer.create(
      :name         => "sip-server.test.invalid",
      :config_port  => nil,
    )
    puts sip_server.inspect
    puts "Errors: #{sip_server.errors.inspect}" if sip_server.errors.length > 0
    assert sip_server.valid?
    
    
    puts "-----------------------------------------------------------"
    puts "Creating a SipProxy without a config_port ..."
    sip_proxy = SipProxy.create(
      :name         => "sip-proxy.test.invalid",
      :config_port  => nil,
    )
    puts sip_proxy.inspect
    puts "Errors: #{sip_proxy.errors.inspect}" if sip_proxy.errors.length > 0
    assert sip_proxy.valid?
    
    
    puts "-----------------------------------------------------------"
    puts "Creating a ProvisioningServer ..."
    provisioning_server = ProvisioningServer.create(
      :name  => "provisioning-server.test.invalid",
      :port  => 4010,
    )
    puts provisioning_server.inspect
    puts "Errors: #{provisioning_server.errors.inspect}" if provisioning_server.errors.length > 0
    assert provisioning_server.valid?
    
    
    number_of_mock_requests = ActiveResource::HttpMock.requests.length
    
    puts "-----------------------------------------------------------"
    puts "Creating a SipAccount without a sip_phone_id ..."
    sip_account = SipAccount.create(
      :user_id        => nil,
      :auth_name      => "mytest",
      :password       => "ksjdfhvasdn",
      :phone_number   => "1234",
      :voicemail_pin  => "1111",
      :sip_server_id  => sip_server.id,
      :sip_proxy_id   => sip_proxy.id,
      :sip_phone_id   => nil,
    )
    puts sip_account.inspect
    puts "Errors: #{sip_account.errors.inspect}" if sip_account.errors.length > 0
    assert sip_account.valid?
    
    puts "Asserting that the SipAccount didn't make requests to other services ..."
    assert_equal( number_of_mock_requests, ActiveResource::HttpMock.requests.length )
    
    
    puts "-----------------------------------------------------------"
    puts "Setting a config_port for the SipServer ..."
    sip_server.update_attributes!( :config_port => 4020 )
    puts sip_server.inspect
    puts "Errors: #{sip_server.errors.inspect}" if sip_server.errors.length > 0
    assert sip_server.valid?
    
    
    puts "-----------------------------------------------------------"
    puts "Setting a config_port for the SipProxy ..."
    sip_proxy.update_attributes!( :config_port => 4030 )
    puts sip_proxy.inspect
    puts "Errors: #{sip_proxy.errors.inspect}" if sip_proxy.errors.length > 0
    assert sip_proxy.valid?
    
    
    number_of_mock_requests = ActiveResource::HttpMock.requests.length
    
    puts "-----------------------------------------------------------"
    puts "Updating the SipAccount ..."
    sip_account.update_attributes!( :password => "sfuerbc" )
    puts sip_account.inspect
    puts "Errors: #{sip_account.errors.inspect}" if sip_account.errors.length > 0
    assert sip_account.valid?
    
    puts "Asserting that the SipAccount didn't make requests to other services ..."
    assert_equal( number_of_mock_requests, ActiveResource::HttpMock.requests.length )
    
    
    number_of_mock_requests = ActiveResource::HttpMock.requests.length
    
    puts "-----------------------------------------------------------"
    puts "Creating a SipPhone ..."
    sip_phone = SipPhone.create(
      :provisioning_server_id => provisioning_server.id,
      :phone_id               => 99991,
    )
    puts sip_phone.inspect
    puts "Errors: #{sip_phone.errors.inspect}" if sip_phone.errors.length > 0
    assert sip_phone.valid?
    
    puts "Asserting that the SipPhone didn't make requests to other services ..."
    assert_equal( number_of_mock_requests, ActiveResource::HttpMock.requests.length )
    
    
    number_of_mock_requests = ActiveResource::HttpMock.requests.length
    
    puts "-----------------------------------------------------------"
    puts "Creating a SipPhone ..."
    sip_phone2 = SipPhone.create(
      :provisioning_server_id => provisioning_server.id,
      :phone_id               => 99992,
    )
    puts sip_phone2.inspect
    puts "Errors: #{sip_phone2.errors.inspect}" if sip_phone2.errors.length > 0
    assert sip_phone2.valid?
    
    puts "Asserting that the SipPhone didn't make requests to other services ..."
    assert_equal( number_of_mock_requests, ActiveResource::HttpMock.requests.length )
    
    
    puts "-----------------------------------------------------------"
    puts "Assigning the SipAccount to the SipPhone ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_accounts = [
      ]
      mock.get    "/sip_accounts.xml", {},
        cantina_sip_accounts.to_xml( :root => "sip-accounts" ), 200, {}
      mock.post   "/sip_accounts.xml", {},
        nil, 201, { "Location" => "/sip_accounts/ignored.xml" }
    }
    
    sip_account.update_attributes!( :sip_phone_id => sip_phone.id )
    puts sip_account.inspect
    puts "Errors: #{sip_account.errors.inspect}" if sip_account.errors.length > 0
    assert sip_account.valid?
    
    puts "Asserting that the mock received the expected request (GET /sip_accounts.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    puts "Asserting that the mock received the expected request (POST /sip_accounts.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :post, "/sip_accounts.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['sip_account'] )
    req_obj_hash = req_obj_hash['sip_account']
    {
      'auth_user'       => 'mytest',
      'user'            => 'mytest',
      'password'        => 'sfuerbc',
      'realm'           => nil,
      'phone_id'        => 99991,
      'registrar'       => 'sip-server.test.invalid',
      'registrar_port'  => nil,
      'sip_proxy'       => 'sip-proxy.test.invalid',
      'sip_proxy_port'  => nil,
      'registration_expiry_time' => 300,
      'dtmf_mode'       => 'rfc2833',
    }.each { |k,v| assert_equal( v, req_obj_hash[k] ) }
    
    ActiveResource::HttpMock.reset!
    
    
    puts "-----------------------------------------------------------"
    puts "Assigning the SipAccount to the SipPhone 2 ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_account_on_phone1 = {
        :id              => 1,
        :auth_user       => 'mytest',
        :user            => 'mytest',
        :password        => 'sfuerbc',
        :realm           => nil,
        :phone_id        => 99991,
        :registrar       => 'sip-server.test.invalid',
        :registrar_port  => nil,
        :sip_proxy       => 'sip-proxy.test.invalid',
        :sip_proxy_port  => nil,
        :registration_expiry_time => 300,
        :dtmf_mode       => 'rfc2833',
      }
      cantina_sip_account_on_phone2 = cantina_sip_account_on_phone1.dup
      cantina_sip_account_on_phone2[:phone_id] = 99992
      mock.get    "/sip_accounts.xml", {},
        [ cantina_sip_account_on_phone1 ].to_xml( :root => "sip-accounts" ), 200, {}
      mock.put    "/sip_accounts/1.xml", {},
        nil, 204, {}
      mock.get    "/sip_accounts/1.xml", {},
        cantina_sip_account_on_phone2.to_xml( :root => "sip-account" ), 200, {}
      mock.delete "/sip_accounts/1.xml", {},
        nil, 200, {}
      #FIXME - why does this need a DELETE?
    }
    
    sip_account.update_attributes!( :sip_phone_id => sip_phone2.id )
    puts sip_account.inspect
    puts "Errors: #{sip_account.errors.inspect}" if sip_account.errors.length > 0
    assert sip_account.valid?
    
    puts "Asserting that the mock received the expected request (GET /sip_accounts.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    puts "Asserting that the mock received the expected request (PUT /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :put, "/sip_accounts/1.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['sip_account'] )
    req_obj_hash = req_obj_hash['sip_account']
    {
      'auth_user'       => 'mytest',
      'user'            => 'mytest',
      'password'        => 'sfuerbc',
      'realm'           => nil,
      'phone_id'        => 99991,
      'registrar'       => 'sip-server.test.invalid',
      'registrar_port'  => nil,
      'sip_proxy'       => 'sip-proxy.test.invalid',
      'sip_proxy_port'  => nil,
      'registration_expiry_time' => 300,
      'dtmf_mode'       => 'rfc2833',
    }.each { |k,v| assert_equal( v, req_obj_hash[k] ) }
    
    puts "Asserting that the mock received the expected request (GET /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    puts "Asserting that the mock received the expected request (DELETE /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :delete, "/sip_accounts/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    ActiveResource::HttpMock.reset!
    
    
    puts "-----------------------------------------------------------"
    puts "Assigning the SipAccount to no SipPhone ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_account_on_phone2 = {
        :id              => 1,
        :auth_user       => 'mytest',
        :user            => 'mytest',
        :password        => 'sfuerbc',
        :realm           => nil,
        :phone_id        => 99992,
        :registrar       => 'sip-server.test.invalid',
        :registrar_port  => nil,
        :sip_proxy       => 'sip-proxy.test.invalid',
        :sip_proxy_port  => nil,
        :registration_expiry_time => 300,
        :dtmf_mode       => 'rfc2833',
      }
      mock.get    "/sip_accounts.xml", {},
        [ cantina_sip_account_on_phone2 ].to_xml( :root => "sip-accounts" ), 200, {}
      mock.get    "/sip_accounts/1.xml", {},
        cantina_sip_account_on_phone2.to_xml( :root => "sip-account" ), 200, {}
      mock.delete "/sip_accounts/1.xml", {},
        nil, 200, {}
    }
    
    sip_account.update_attributes!( :sip_phone_id => nil )
    puts sip_account.inspect
    puts "Errors: #{sip_account.errors.inspect}" if sip_account.errors.length > 0
    assert sip_account.valid?
    
    puts "Asserting that the mock received the expected request (GET /sip_accounts.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    puts "Asserting that the mock received the expected request (GET /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    puts "Asserting that the mock received the expected request (DELETE /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :delete, "/sip_accounts/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    ActiveResource::HttpMock.reset!
    
  end
  
  
end
