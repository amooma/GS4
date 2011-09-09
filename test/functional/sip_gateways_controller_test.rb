require 'test_helper'

class SipGatewaysControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @sip_gateway = Factory.create(:sip_gateway)
    
    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
    
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
  end
  
  
  test "should get index" do
    sign_in :user, @admin_user
    get :index
    assert_response :success
    assert_not_nil( assigns(:sip_gateways))
    sign_out @admin_user
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
  
  
  test "should create sip_gateway - version b" do
    sign_in :user, @admin_user
    assert_difference('SipGateway.count') {
      sip_gateway = Factory.build(:sip_gateway)
      post :create, :sip_gateway => sip_gateway.attributes
    }
    assert_redirected_to( sip_gateway_path( assigns(:sip_gateway)))
    sign_out @admin_user
  end
  
  test "should create sip_gateway - version c" do
    sign_in :user, @admin_user
    assert_difference('SipGateway.count') {
      post :create, :sip_gateway => Factory.attributes_for(:sip_gateway)
    }
    assert_redirected_to( sip_gateway_path( assigns(:sip_gateway)))
    sign_out @admin_user
  end
  
  test "should not create sip_gateway (not an admin) - version a" do
    assert_no_difference('SipGateway.count') {
      post :create, :sip_gateway => @sip_gateway.attributes.reject{ |k,v| k.to_s == 'id' }
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  test "should not create sip_gateway (not an admin) - version b" do
    assert_no_difference('SipGateway.count') {
      sip_gateway = Factory.build(:sip_gateway)
      post :create, :sip_gateway => sip_gateway.attributes
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  test "should not create sip_gateway (not an admin) - version c" do
    assert_no_difference('SipGateway.count') {
      post :create, :sip_gateway => Factory.attributes_for(:sip_gateway)
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show sip_gateway" do
    sign_in :user, @admin_user
    get :show, :id => @sip_gateway.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show sip_gateway (not an admin)" do
    get :show, :id => @sip_gateway.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @sip_gateway.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @sip_gateway.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update sip_gateway" do
    sign_in :user, @admin_user
    put :update, :id => @sip_gateway.to_param, :sip_gateway => @sip_gateway.attributes.reject{ |k,v| k.to_s == 'id' }
    assert_redirected_to( sip_gateway_path( assigns(:sip_gateway)))
    sign_out @admin_user
  end
  
  test "should not update sip_gateway (not an admin)" do
    put :update, :id => @sip_gateway.to_param, :sip_gateway => @sip_gateway.attributes.reject{ |k,v| k.to_s == 'id' }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy sip_gateway" do
    sign_in :user, @admin_user
    assert_difference('SipGateway.count', -1) {
      delete :destroy, :id => @sip_gateway.to_param
    }
    assert_redirected_to( sip_gateways_path )
    sign_out @admin_user
  end
  
  test "should not destroy sip_gateway (not an admin)" do
    assert_no_difference('SipGateway.count') {
      delete :destroy, :id => @sip_gateway.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
end
