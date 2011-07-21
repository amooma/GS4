require 'test_helper'

class ConfigurationsControllerTest < ActionController::TestCase
  
  setup do
    @configuration = Factory.create(:configuration)

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
    assert_not_nil assigns(:configurations)
    sign_out @admin_user
  end
  
  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should create configuration" do
    sign_in :user, @admin_user
    assert_difference('Configuration.count') do
      configuration = Factory.build(:configuration)
      post :create, :configuration => configuration.attributes
    end
    assert_redirected_to configuration_path(assigns(:configuration))
    sign_out @admin_user
  end
  
  test "should show configuration" do
    sign_in :user, @admin_user
    get :show, :id => @configuration.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @configuration.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should update configuration" do
    sign_in :user, @admin_user
    put :update, :id => @configuration.to_param, :configuration => @configuration.attributes
    assert_redirected_to configuration_path(assigns(:configuration))
    sign_out @admin_user
  end
  
  test "should destroy configuration" do
    sign_in :user, @admin_user
    assert_difference('Configuration.count', -1) do
      delete :destroy, :id => @configuration.to_param
    end
    assert_redirected_to configurations_path
    sign_out @admin_user
  end
  
end
