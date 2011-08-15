require 'test_helper'

class NetworkSettingsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @network_setting = network_settings(:one)
    
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
    assert_not_nil( assigns(:network_settings))
    sign_out @admin_user
  end
  
  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not create network_setting" do
    sign_in :user, @admin_user
    post :create, :network_setting => @network_setting.attributes
    assert_response( 200 )  #FIXME Fix the assert or the test name.
    sign_out @admin_user
  end
  
  test "should show network_setting" do
    sign_in :user, @admin_user
    get :show, :id => @network_setting.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @network_setting.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should destroy network_setting" do
    sign_in :user, @admin_user
    delete :destroy, :id => @network_setting.to_param
    assert_response( 403 )  #FIXME Fix the assert or the test name.
    sign_out @admin_user
  end
  
end
