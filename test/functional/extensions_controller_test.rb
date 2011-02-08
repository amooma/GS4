require 'test_helper'

class ExtensionsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @extension = extensions(:one)
    
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
    assert_not_nil( assigns(:extensions))
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
  
  
  test "should create extension" do
    sign_in :user, @admin_user
    assert_difference('Extension.count') {
      post :create, :extension => @extension.attributes
    }
    assert_redirected_to( extension_path( assigns(:extension)))
    sign_out @admin_user
  end
  
  test "should not create extension (not an admin)" do
    assert_no_difference('Extension.count') {
      post :create, :extension => @extension.attributes
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show extension" do
    sign_in :user, @admin_user
    get :show, :id => @extension.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show extension (not an admin)" do
    get :show, :id => @extension.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @extension.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @extension.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update extension" do
    sign_in :user, @admin_user
    put :update, :id => @extension.to_param, :extension => @extension.attributes
    assert_redirected_to( extension_path( assigns(:extension)))
    sign_out @admin_user
  end
  
  test "should not update extension (not an admin)" do
    put :update, :id => @extension.to_param, :extension => @extension.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy extension" do
    sign_in :user, @admin_user
    assert_difference('Extension.count', -1) {
      delete :destroy, :id => @extension.to_param
    }
    assert_redirected_to( extensions_path )
    sign_out @admin_user
  end
  
  test "should not destroy extension (not an admin)" do
    assert_no_difference('Extension.count') {
      delete :destroy, :id => @extension.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
end
