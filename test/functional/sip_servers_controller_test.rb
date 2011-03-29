require 'test_helper'
# TODO Testing moving accounts when creating new server
class SipServersControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @sip_server = Factory.create(:sip_server)
    
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
    assert_not_nil( assigns(:sip_servers))
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
  
  
  test "should create sip_server" do
    sign_in :user, @admin_user
    assert_difference('SipServer.count') {
      post :create, :sip_server => Factory.attributes_for(:sip_server)
    }
    assert_redirected_to( sip_server_path( assigns(:sip_server)))
    sign_out @admin_user
  end
  
  test "should not create sip_server (not an admin)" do
    assert_no_difference('SipServer.count') {
      post :create, :sip_server => Factory.attributes_for(:sip_server)
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show sip_server" do
    sign_in :user, @admin_user
    get :show, :id => @sip_server.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show sip_server (not an admin)" do
    get :show, :id => @sip_server.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should not get edit" do
    sign_in :user, @admin_user
    assert_raise(ActionController::RoutingError) do
      get :edit, :id => @sip_server.to_param
    end
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    assert_raise(ActionController::RoutingError) do
      get :edit, :id => @sip_server.to_param
    end
  end
  
  
  test "should not update sip_server" do
    sign_in :user, @admin_user
    assert_raise(ActionController::RoutingError)do
    put :update, :id => @sip_server.to_param, :sip_server => @sip_server.attributes
  end
  sign_out @admin_user
end

test "should not update sip_server (not an admin)" do
  assert_raise(ActionController::RoutingError) do
    put :update, :id => @sip_server.to_param, :sip_server => @sip_server.attributes
  end
end


test "should destroy sip_server" do
  sign_in :user, @admin_user
  assert_difference('SipServer.count', -1) {
    delete :destroy, :id => @sip_server.to_param
  }
  assert_redirected_to( sip_servers_path )
  sign_out @admin_user
end

test "should not destroy sip_server (not an admin)" do
  assert_no_difference('SipServer.count') {
    delete :destroy, :id => @sip_server.to_param
  }
  assert_response( @expected_http_status_if_not_allowed )
end


end
