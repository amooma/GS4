require 'test_helper'
class SipProxiesControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  # TODO Test moving accounts when creating new server
  
  setup do
    @sip_proxy = Factory.create(:sip_proxy)
    
    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
    
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
    @expected_http_status_if_no_route = 404
  end
  
  
  test "should get index" do
    sign_in :user, @admin_user
    get :index
    assert_response :success
    assert_not_nil( assigns(:sip_proxies))
    sign_out @admin_user
  end
  
  test "should not get index (not an admin)" do
    get :index
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should not get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get new (not an admin)" do
    get :new
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should create sip_proxy" do
    sign_in :user, @admin_user
    assert_difference('SipProxy.count') {
      post :create, :sip_proxy => Factory.attributes_for(:sip_proxy)
    }
    assert_redirected_to( sip_proxy_path( assigns(:sip_proxy)))
    sign_out @admin_user
  end
  
  test "should not create sip_proxy (not an admin)" do
    assert_no_difference('SipProxy.count') {
      post :create, :sip_proxy => Factory.attributes_for(:sip_proxy)
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show sip_proxy" do
    sign_in :user, @admin_user
    get :show, :id => @sip_proxy.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show sip_proxy (not an admin)" do
    get :show, :id => @sip_proxy.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should not get edit" do
    sign_in :user, @admin_user
    assert_raise(ActionController::RoutingError) {
      get :edit, :id => @sip_proxy.to_param
    }
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    assert_raise(ActionController::RoutingError) {
      get :edit, :id => @sip_proxy.to_param
    }
  end
  
  
  test "should not update sip_proxy" do
    sign_in :user, @admin_user
    assert_raise(ActionController::RoutingError) {
      put :update, :id => @sip_proxy.to_param, :sip_proxy => @sip_proxy.attributes
    }
    sign_out @admin_user
  end
  
  test "should not update sip_proxy (not an admin)" do
    assert_raise(ActionController::RoutingError) {
      put :update, :id => @sip_proxy.to_param, :sip_proxy => @sip_proxy.attributes
    }
  end
  
  
  test "should destroy sip_proxy" do
    sign_in :user, @admin_user
    assert_difference('SipProxy.count', -1) {
      delete :destroy, :id => @sip_proxy.to_param
    }
    assert_redirected_to( sip_proxies_path )
    sign_out @admin_user
  end
  
  test "should not destroy sip_proxy (not an admin)" do
    assert_no_difference('SipProxy.count') {
      delete :destroy, :id => @sip_proxy.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
end
