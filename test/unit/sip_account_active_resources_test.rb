require 'test_helper'

class SipAccountTest < ActiveSupport::TestCase
  
  def create_sip_account_without_phone
    @sip_server = Factory.create(:sip_server,
      :management_host => "10.5.5.1",
      :management_port => 4041
    )
    @sip_proxy  = Factory.create(:sip_proxy)
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      mock.post   "/subscribers.xml", {},  # POST = create
        nil, 201, { "Location" => "/subscribers/1.xml" }
      mock.post   "/dbaliases.xml", {},  # POST = create
        nil, 201, { "Location" => "/dbaliases/1.xml" }
    }
    @sip_account = Factory.create(:sip_account,
      :sip_server_id => @sip_server.id,
      :sip_proxy_id  => @sip_proxy.id,
      :sip_phone_id  => nil
    )
  end
  
  def create_sip_account_and_phones
    @provisioning_server = Factory.create(:provisioning_server)
    @sip_phone_1 = Factory.create(:sip_phone,
      :provisioning_server_id => @provisioning_server.id
    )
    @sip_phone_2 = Factory.create(:sip_phone,
      :provisioning_server_id => @provisioning_server.id
    )
    @sip_server  = Factory.create(:sip_server,
      :management_host => "10.5.5.2",
      :management_port => 4042
    )
    @sip_proxy   = Factory.create(:sip_proxy,
      :management_host => "10.5.5.3",
      :management_port => 4043
    )
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      mock.post   "/subscribers.xml", {},  # POST = create
        nil, 201, { "Location" => "/subscribers/1.xml" }
      mock.post   "/dbaliases.xml", {},  # POST = create
        nil, 201, { "Location" => "/dbaliases/1.xml" }
    }
    @sip_account = Factory.create(:sip_account,
      :sip_server_id => @sip_server.id,
      :sip_proxy_id  => @sip_proxy.id,
      :sip_phone_id  => nil
    )
  end
  
  
  # testing active resources of sip_account (external servers)
  
  
  ################################################################
  should "not make requests if sip_phone_id is nil" do
    ActiveResource::HttpMock.reset!
    number_of_mock_requests = ActiveResource::HttpMock.requests.length
    
    sip_server = Factory.create(:sip_server, :management_port => nil)
    sip_proxy  = Factory.create(:sip_proxy)
    
    sip_account = Factory.create(:sip_account,
      :sip_server_id => sip_server.id,
      :sip_proxy_id  => sip_proxy.id,
      :sip_phone_id  => nil
    )
    
    assert_equal( number_of_mock_requests, ActiveResource::HttpMock.requests.length )
  end
  
  
  ################################################################
  should "create subscriber and alias on sip_proxy server" do
    ActiveResource::HttpMock.reset!
    
    create_sip_account_without_phone
    assert @sip_account.valid?
    
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :post, "/subscribers.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['subscriber'], 'Request expected to contain "subscriber" as root' )
    req_obj_hash = req_obj_hash['subscriber']
    {
      'username'    => @sip_account.auth_name,
      'domain'      => @sip_account.sip_server.host,
      'password'    => @sip_account.password,
      'ha1'         => Digest::MD5.hexdigest( "#{req_obj_hash['username']}:#{req_obj_hash['domain']}:#{@sip_account.password}" ),
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
    
    
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :post, "/dbaliases.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['dbalias'], 'Request expected to contain "dbalias" as root' )
    req_obj_hash = req_obj_hash['dbalias']
    {
      'username'        => @sip_account.auth_name,
      'domain'          => @sip_account.sip_server.host,
      'alias_username'  => @sip_account.phone_number,
      'alias_domain'    => @sip_account.sip_server.host
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
  end
  
  
  ################################################################
  should "update subscriber on sip_proxy" do
    
    create_sip_account_without_phone
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      sip_proxy_subscriber = {
        :id          => 1,
        :username    => @sip_account.auth_name,
        :domain      => @sip_account.sip_server.host,
        :password    => @sip_account.password,
        :ha1         => Digest::MD5.hexdigest( "#{@sip_account.auth_name}:#{@sip_account.sip_server.host}:#{@sip_account.password}" )
      }
      
      mock.get   "/subscribers.xml?username=#{@sip_account.auth_name}", {}, # GET = index
        [ sip_proxy_subscriber ].to_xml(:root => "subscribers"), 200, {}
      mock.put    "/subscribers/1.xml", {},  # PUT = update
        nil, 204, {}
    }  
    
    @sip_account.update_attributes!( :password => "x3u89" )
    
    #puts "Asserting that the mock received the expected request (GET /subscribers.xml?username=mytest) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/subscribers.xml?username=#{@sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (POST /subscribers.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :put, "/subscribers/1.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['subscriber'], 'Request expected to contain "subscriber" as root' )
    req_obj_hash = req_obj_hash['subscriber']
    {
      'username'    => @sip_account.auth_name,
      'domain'      => @sip_account.sip_server.host,
      'password'    => @sip_account.password,
      'ha1'         => Digest::MD5.hexdigest( "#{req_obj_hash['username']}:#{req_obj_hash['domain']}:#{@sip_account.password}" ),
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
    
    ActiveResource::HttpMock.reset!
  end
  
  
  ################################################################
  should "move SIP account from one phone to another phone" do
    ActiveResource::HttpMock.reset!
    create_sip_account_and_phones
        
    #puts "Assigning the SipAccount to SipPhone 1 ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_accounts = [
      ]
      mock.get    "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", {},  # GET = index
        cantina_sip_accounts.to_xml( :root => "sip-accounts" ), 200, {}
      mock.post   "/sip_accounts.xml", {},  # POST = create
        nil, 201, { "Location" => "/sip_accounts/ignored.xml" }
    }
    
    @sip_account.update_attributes!( :sip_phone_id => @sip_phone_1.id )
    puts "Errors: #{sip_account.errors.inspect}" if @sip_account.errors.length > 0
    assert @sip_account.valid?
    
    #puts "Asserting that the mock received the expected request (GET /sip_accounts.xml?auth_user=#{@sip_account.auth_name}) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (POST /sip_accounts.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :post, "/sip_accounts.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['sip_account'], 'Request expected to contain "sip_account" as root' )
    req_obj_hash = req_obj_hash['sip_account']
    {
      'auth_user'           => @sip_account.auth_name,
      'user'                => @sip_account.auth_name,
      'password'            => @sip_account.password,
      'realm'               => @sip_account.realm,
      'phone_id'            => @sip_phone_1.phone_id,
      'registrar'           => @sip_account.sip_server.host,
      'registrar_port'      => @sip_account.sip_server.port,
      'outbound_proxy'      => @sip_account.sip_proxy.host,
      'outbound_proxy_port' => @sip_account.sip_proxy.port,
      'sip_proxy'           => @sip_account.sip_proxy.host,
      'sip_proxy_port'      => @sip_account.sip_proxy.port,
      'registration_expiry_time' => 300,
      'dtmf_mode'           => 'rfc2833',
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
    
    
    #puts "Assigning the SipAccount to SipPhone 2 ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_account_on_phone1 = {
        :id                  => 1,
        :auth_user           => @sip_account.auth_name,
        :user                => @sip_account.auth_name,
        :password            => @sip_account.password,
        :realm               => @sip_account.realm,
        :phone_id            => @sip_phone_1.phone_id,
        :registrar           => @sip_account.sip_server.host,
        :registrar_port      => @sip_account.sip_server.port,
        :outbound_proxy      => @sip_account.sip_proxy.host,
        :outbound_proxy_port => @sip_account.sip_proxy.port,
        :sip_proxy           => @sip_account.sip_proxy.host,
        :sip_proxy_port      => @sip_account.sip_proxy.port,
        :registration_expiry_time => 300,
        :dtmf_mode           => 'rfc2833',
      }
      mock.get    "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", {},  # GET = index
        [ cantina_sip_account_on_phone1 ].to_xml( :root => "sip-accounts" ), 200, {}
      mock.put    "/sip_accounts/1.xml", {},  # PUT = update
        nil, 204, {}
    }
    
    @sip_account.update_attributes!( :sip_phone_id => @sip_phone_2.id )
    #puts @sip_account.inspect
    puts "Errors: #{@sip_account.errors.inspect}" if @sip_account.errors.length > 0
    assert @sip_account.valid?
    
    #puts "Asserting that the mock received the expected request (GET /sip_accounts.xml?auth_user=#{@sip_account.auth_name}) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (PUT /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :put, "/sip_accounts/1.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['sip_account'], 'Request expected to contain "sip_account" as root' )
    req_obj_hash = req_obj_hash['sip_account']
    {
      'auth_user'           => @sip_account.auth_name,
      'user'                => @sip_account.auth_name,
      'password'            => @sip_account.password,
      'realm'               => @sip_account.realm,
      'phone_id'            => @sip_phone_1.phone_id,
      'registrar'           => @sip_account.sip_server.host,
      'registrar_port'      => @sip_account.sip_server.port,
      'outbound_proxy'      => @sip_account.sip_proxy.host,
      'outbound_proxy_port' => @sip_account.sip_proxy.port,
      'sip_proxy'           => @sip_account.sip_proxy.host,
      'sip_proxy_port'      => @sip_account.sip_proxy.port,
      'registration_expiry_time' => 300,
      'dtmf_mode'           => 'rfc2833',
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
    
    
    #puts "Updating the SipAccount while it's assigned to a phone ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_account_on_phone1 = {
        :id                  => 1,
        :auth_user           => @sip_account.auth_name,
        :user                => @sip_account.auth_name,
        :password            => @sip_account.password,
        :realm               => @sip_account.realm,
        :phone_id            => @sip_phone_1.phone_id,
        :registrar           => @sip_account.sip_server.host,
        :registrar_port      => @sip_account.sip_server.port,
        :outbound_proxy      => @sip_account.sip_proxy.host,
        :outbound_proxy_port => @sip_account.sip_proxy.port,
        :sip_proxy           => @sip_account.sip_proxy.host,
        :sip_proxy_port      => @sip_account.sip_proxy.port,
        :registration_expiry_time => 300,
        :dtmf_mode           => 'rfc2833',
      }
      cantina_sip_account_on_phone2 = cantina_sip_account_on_phone1.dup
      cantina_sip_account_on_phone2[:phone_id] = @sip_phone_2.phone_id
      
      sipproxy_subscriber2 = {
        :id          => 1,
        :username    => @sip_account.auth_name,
        :domain      => @sip_account.sip_server.host,
        :ha1         => Digest::MD5.hexdigest( "#{@sip_account.auth_name}:#{@sip_account.sip_server.host}:#{@sip_account.password}" ),
      }
      
      mock.get    "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", {},  # GET = index
        [ cantina_sip_account_on_phone2 ].to_xml( :root => "sip-accounts" ), 200, {}
      mock.put    "/sip_accounts/1.xml", {},  # PUT = update
        nil, 204, {}
      
      mock.get    "/subscribers.xml?username=#{@sip_account.auth_name}", {},  # GET = index
        [ sipproxy_subscriber2 ].to_xml( :root => "subscribers" ), 200, {}
      mock.put    "/subscribers/1.xml", {},  # PUT = update
        nil, 204, {}
    }
    
    @sip_account.update_attributes!( :password => "e99w2oc4" )
    #TODO Test an update of auth_name as well.
    #puts @sip_account.inspect
    puts "Errors: #{@sip_account.errors.inspect}" if @sip_account.errors.length > 0
    assert @sip_account.valid?
    
    #puts "Asserting that the mock received the expected request (GET /sip_accounts.xml?auth_user=#{@sip_account.auth_name}) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (PUT /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :put, "/sip_accounts/1.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['sip_account'], 'Request expected to contain "sip_account" as root' )
    req_obj_hash = req_obj_hash['sip_account']
    {
      'auth_user'           => @sip_account.auth_name,
      'user'                => @sip_account.auth_name,
      'password'            => @sip_account.password,
      'realm'               => @sip_account.realm,
      'phone_id'            => @sip_phone_1.phone_id,
      'registrar'           => @sip_account.sip_server.host,
      'registrar_port'      => @sip_account.sip_server.port,
      'outbound_proxy'      => @sip_account.sip_proxy.host,
      'outbound_proxy_port' => @sip_account.sip_proxy.port,
      'sip_proxy'           => @sip_account.sip_proxy.host,
      'sip_proxy_port'      => @sip_account.sip_proxy.port,
      'registration_expiry_time' => 300,
      'dtmf_mode'           => 'rfc2833',
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
    
    #puts "Asserting that the mock received the expected request (GET /subscribers.xml?username=mytest) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/subscribers.xml?username=#{@sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (PUT /subscribers/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      # Note that ActiveResource::Request.==() does not check equality
      # of the body, so neither .include?() not .index() alone is enough.
      ActiveResource::Request.new(
        :put, "/subscribers/1.xml", nil, { "Content-Type"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    req_obj_hash = Hash.from_xml( ActiveResource::HttpMock.requests[idx].body )
    assert_not_equal( nil, req_obj_hash )
    assert_not_equal( nil, req_obj_hash['subscriber'], 'Request expected to contain "subscriber" as root' )
    req_obj_hash = req_obj_hash['subscriber']
    {
      'username'    => @sip_account.auth_name,
      'domain'      => @sip_account.sip_server.host,
      'password'    => @sip_account.password,
      'ha1'         => Digest::MD5.hexdigest( "#{req_obj_hash['username']}:#{req_obj_hash['domain']}:#{@sip_account.password}" ),
    }.each { |k,v| assert_equal( v, req_obj_hash[k], "Request expected to contain attribute #{k.inspect} = #{v.inspect} but is #{req_obj_hash[k].inspect}" ) }
    
    ActiveResource::HttpMock.reset!
    
    
    #puts "Assigning the SipAccount to no SipPhone ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      cantina_sip_account_on_phone1 = {
        :id                  => 1,
        :auth_user           => @sip_account.auth_name,
        :user                => @sip_account.auth_name,
        :password            => @sip_account.password,
        :realm               => @sip_account.realm,
        :phone_id            => @sip_phone_1.phone_id,
        :registrar           => @sip_account.sip_server.host,
        :registrar_port      => @sip_account.sip_server.port,
        :outbound_proxy      => @sip_account.sip_proxy.host,
        :outbound_proxy_port => @sip_account.sip_proxy.port,
        :sip_proxy           => @sip_account.sip_proxy.host,
        :sip_proxy_port      => @sip_account.sip_proxy.port,
        :registration_expiry_time => 300,
        :dtmf_mode           => 'rfc2833',
      }
      cantina_sip_account_on_phone2 = cantina_sip_account_on_phone1.dup
      cantina_sip_account_on_phone2[:phone_id] = @sip_phone_2.phone_id
      cantina_sip_account_on_phone2_v2 = cantina_sip_account_on_phone2.dup
      cantina_sip_account_on_phone2_v2[:password] = @sip_account.password
      
      mock.get    "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", {},  # GET = index
        [ cantina_sip_account_on_phone2_v2 ].to_xml( :root => "sip-accounts" ), 200, {}
      #mock.get    "/sip_accounts/1.xml", {},  # GET = show
      #  cantina_sip_account_on_phone2_v2.to_xml( :root => "sip-account" ), 200, {}
      mock.delete "/sip_accounts/1.xml", {},  # DELETE = destroy
        nil, 200, {}
    }
    
    @sip_account.update_attributes!( :sip_phone_id => nil )
    #puts @sip_account.inspect
    puts "Errors: #{@sip_account.errors.inspect}" if @sip_account.errors.length > 0
    assert @sip_account.valid?
    
    #puts "Asserting that the mock received the expected request (GET /sip_accounts.xml?auth_user=#{@sip_account.auth_name}) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/sip_accounts.xml?auth_user=#{@sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    ##puts "Asserting that the mock received the expected request (GET /sip_accounts/1.xml) from the model ..."
    #idx = ActiveResource::HttpMock.requests.index(
    #  ActiveResource::Request.new(
    #    :get, "/sip_accounts/1.xml", nil, { "Accept"=>"application/xml" } )
    #)
    #assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (DELETE /sip_accounts/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :delete, "/sip_accounts/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    ActiveResource::HttpMock.reset!
    
    
    #puts "Deleting the SipAccount ..."
    
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      sipproxy_subscriber3 = {
        :id          => 1,
        :username    => @sip_account.auth_name,
        :domain      => @sip_account.sip_server.host,
        :ha1         => Digest::MD5.hexdigest( "#{@sip_account.auth_name}:#{@sip_account.sip_server.host}:#{@sip_account.password}" ),
      }
      sipproxy_dbalias3 = {
        :id              => 1,
        :username        => @sip_account.auth_name,
        :domain          => @sip_account.sip_server.host,
        :alias_username  => '1234',
        :alias_domain    => @sip_account.sip_server.host,
        :subscriber_id   => 1,
      }
      mock.get    "/subscribers.xml?username=#{@sip_account.auth_name}", {},  # GET = index
        [ sipproxy_subscriber3 ].to_xml( :root => "subscribers" ), 200, {}
      mock.delete "/subscribers/1.xml", {},  # DELETE = destroy
        nil, 200, {}
      mock.get     "/dbaliases.xml?alias_username=#{@sip_account.phone_number}&username=#{@sip_account.auth_name}", {},  # GET = index
        [ sipproxy_dbalias3 ].to_xml( :root => "dbaliases" ), 200, {}
      mock.delete "/dbaliases/1.xml", {},  # DELETE = destroy
        nil, 200, {}
    }
    
    deleted_sip_account = @sip_account.dup
    #puts deleted_sip_account.inspect
    
    @sip_account.destroy
    assert_not_equal( nil, deleted_sip_account )
    #puts @sip_account.inspect
    puts "Errors: #{@sip_account.errors.inspect}" if @sip_account && @sip_account.errors.length > 0
    begin; @sip_account.reload ; rescue ActiveRecord::RecordNotFound => e; @sip_account = nil; end
    assert_equal( nil, @sip_account )
    
    #puts "Asserting that the mock received the expected request (GET /subscribers.xml?username=#{deleted_sip_account.auth_name}) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/subscribers.xml?username=#{deleted_sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (DELETE /subscribers/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :delete, "/subscribers/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (GET /dbaliases.xml?alias_username=#{deleted_sip_account.phone_number}&username=#{deleted_sip_account.auth_name}) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :get, "/dbaliases.xml?alias_username=#{deleted_sip_account.phone_number}&username=#{deleted_sip_account.auth_name}", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    #puts "Asserting that the mock received the expected request (DELETE /dbaliases/1.xml) from the model ..."
    idx = ActiveResource::HttpMock.requests.index(
      ActiveResource::Request.new(
        :delete, "/dbaliases/1.xml", nil, { "Accept"=>"application/xml" } )
    )
    assert_not_equal( nil, idx )
    
    ActiveResource::HttpMock.reset!
  end
  
end
