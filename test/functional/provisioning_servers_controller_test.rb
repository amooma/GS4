require 'test_helper'

class ProvisioningServersControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @provisioning_server = Factory.create(:provisioning_server)
    
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
    assert_not_nil( assigns(:provisioning_servers))
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
  
  
  test "should create provisioning_server" do
    sign_in :user, @admin_user
    assert_difference('ProvisioningServer.count') {
      post :create, :provisioning_server => @provisioning_server.attributes
    }
    assert_redirected_to( provisioning_server_path( assigns(:provisioning_server)))
    sign_out @admin_user
  end
  
  test "should not create provisioning_server (not an admin)" do
    assert_no_difference('ProvisioningServer.count') {
      post :create, :provisioning_server => @provisioning_server.attributes
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show provisioning_server" do
    sign_in :user, @admin_user
    get :show, :id => @provisioning_server.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show provisioning_server (not an admin)" do
    get :show, :id => @provisioning_server.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @provisioning_server.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @provisioning_server.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update provisioning_server" do
    sign_in :user, @admin_user
    put :update, :id => @provisioning_server.to_param, :provisioning_server => @provisioning_server.attributes
    assert_redirected_to( provisioning_server_path( assigns(:provisioning_server)))
    sign_out @admin_user
  end
  
  test "should not update provisioning_server (not an admin)" do
    put :update, :id => @provisioning_server.to_param, :provisioning_server => @provisioning_server.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy provisioning_server" do
    sign_in :user, @admin_user
    assert_difference('ProvisioningServer.count', -1) {
      delete :destroy, :id => @provisioning_server.to_param
    }
    assert_redirected_to( provisioning_servers_path )
    sign_out @admin_user
  end
  
  test "should not destroy provisioning_server (not an admin)" do
    assert_no_difference('ProvisioningServer.count') {
      delete :destroy, :id => @provisioning_server.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
end
