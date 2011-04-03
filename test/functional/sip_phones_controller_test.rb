require 'test_helper'

class SipPhonesControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    ActiveResource::HttpMock.reset!
    ActiveResource::HttpMock.respond_to { |mock|
      a_cantina_phone = {
        :id               => 0,
        :mac_address      => '000000000000',
        :phone_model_id   => 0,
        :ip_address       => '0.0.0.1',
        :last_ip_address  => nil,
        :http_user        => '',
        :http_password    => '',
      }
      first_factory_phone_phone_id = 4001
      number_of_factory_phones = 8         # equals the number of tests (setup() is run once for each test)
      for cantina_phone_id in (
        (first_factory_phone_phone_id) ..
        (first_factory_phone_phone_id + number_of_factory_phones - 1)
      ) do
        mock.get(    "/phones/#{cantina_phone_id.to_s}.xml", {},  # GET = show
          a_cantina_phone.merge({
            :id               => cantina_phone_id,
            :mac_address      => cantina_phone_id.to_s(16).rjust(12,'0'),
          }).to_xml( :root => "phone" ), 200, {}
        )
      end
    }
    number_of_mock_requests = ActiveResource::HttpMock.requests.length

    @sip_phone = Factory.create(:sip_phone)

    assert( ActiveResource::HttpMock.requests.length > number_of_mock_requests,
      "Factory.create(:sip_phone) is expected to make requests because of the phone_id validation" )
    ActiveResource::HttpMock.reset!
    
    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil @admin_user, "This tests needs user #{an_admin_username.inspect}"
    
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
  end
  
  
   
  test "should not get index (not an admin)" do
    get :index
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get new (not an admin)" do
    get :new
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  
  
  test "should show sip_phone" do
    sign_in :user, @admin_user
    get :show, :id => @sip_phone.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show sip_phone (not an admin)" do
    get :show, :id => @sip_phone.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
    
  test "should not get edit (not an admin)" do
    get :edit, :id => @sip_phone.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  
  test "should not update sip_phone (not an admin)" do
    put :update, :id => @sip_phone.to_param, :sip_phone => @sip_phone.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  
  test "should not destroy sip_phone (not an admin)" do
    assert_no_difference('SipPhone.count') {
      delete :destroy, :id => @sip_phone.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
end
