require 'test_helper'

class DialplanPatternsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @dialplan_pattern = dialplan_patterns(:one)
    
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
    assert_not_nil assigns(:dialplan_patterns)
    sign_out @admin_user
  end
  
  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
=begin
  #OPTIMIZE
  test "should create dialplan_pattern" do
    sign_in :user, @admin_user
    assert_difference('DialplanPattern.count') do
      post :create, :dialplan_pattern => @dialplan_pattern.attributes
    end
    #assert_redirected_to dialplan_pattern_path(assigns(:dialplan_pattern))
    assert_redirected_to dialplan_patterns_path
    sign_out @admin_user
  end
=end
  
  test "should show dialplan_pattern" do
    sign_in :user, @admin_user
    get :show, :id => @dialplan_pattern.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @dialplan_pattern.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should update dialplan_pattern" do
    sign_in :user, @admin_user
    put :update, :id => @dialplan_pattern.to_param, :dialplan_pattern => @dialplan_pattern.attributes
    #assert_redirected_to dialplan_pattern_path(assigns(:dialplan_pattern))
    assert_redirected_to dialplan_patterns_path
    sign_out @admin_user
  end
  
  test "should destroy dialplan_pattern" do
    sign_in :user, @admin_user
    assert_difference('DialplanPattern.count', -1) do
      delete :destroy, :id => @dialplan_pattern.to_param
    end
    assert_redirected_to dialplan_patterns_path
    sign_out @admin_user
  end
  
end
