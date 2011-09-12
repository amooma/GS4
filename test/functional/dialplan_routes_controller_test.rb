require 'test_helper'

class DialplanRoutesControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @dialplan_route = dialplan_routes(:one)
    
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
    assert_not_nil assigns(:dialplan_routes)
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
  test "should create dialplan_route" do
    sign_in :user, @admin_user
    assert_difference('DialplanRoute.count') do
      post :create, :dialplan_route => @dialplan_route.attributes
    end
    #assert_redirected_to dialplan_route_path(assigns(:dialplan_route))
    assert_redirected_to dialplan_routes_path
    sign_out @admin_user
  end
=end
  
  test "should show dialplan_route" do
    sign_in :user, @admin_user
    get :show, :id => @dialplan_route.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @dialplan_route.to_param
    assert_response :success
    sign_out @admin_user
  end
  
=begin
  #OPTIMIZE
  test "should update dialplan_route" do
    sign_in :user, @admin_user
    put :update, :id => @dialplan_route.to_param, :dialplan_route => @dialplan_route.attributes
    #assert_redirected_to dialplan_route_path(assigns(:dialplan_route))
    assert_redirected_to dialplan_routes_path
    sign_out @admin_user
  end
=end
  
  test "should destroy dialplan_route" do
    sign_in :user, @admin_user
    assert_difference('DialplanRoute.count', -1) do
      delete :destroy, :id => @dialplan_route.to_param
    end
    assert_redirected_to dialplan_routes_path
    sign_out @admin_user
  end
  
end
