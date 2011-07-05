require 'test_helper'

class CallForwardsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @call_forward = Factory.create( :call_forward )
    
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
    assert_not_nil assigns(:call_forwards)
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
  
  
  test "should create call_forward" do
    sign_in :user, @admin_user
    call_forward = Factory.build(:call_forward)
    assert_difference('CallForward.count') {
      post :create, :call_forward => call_forward.attributes
    }
    assert_redirected_to( call_forward_path( assigns(:call_forward)))
    sign_out @admin_user
  end
  
  test "should not create call_forward (not an admin)" do
    call_forward = Factory.build(:call_forward)
    assert_no_difference('CallForward.count') {
      post :create, :call_forward => call_forward.attributes
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show call_forward" do
    sign_in :user, @admin_user
    get :show, :id => @call_forward.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show call_forward (not an admin)" do
    get :show, :id => @call_forward.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @call_forward.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @call_forward.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update call_forward" do
    sign_in :user, @admin_user
    put :update, :id => @call_forward.to_param, :call_forward => @call_forward.attributes
    assert_redirected_to( call_forward_path( assigns(:call_forward)))
    sign_out @admin_user
  end
  
  test "should not update call_forward (not an admin)" do
    put :update, :id => @call_forward.to_param, :call_forward => @call_forward.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy call_forward" do
    sign_in :user, @admin_user
    assert_difference('CallForward.count', -1) {
      delete :destroy, :id => @call_forward.to_param
    }
    assert_redirected_to( call_forwards_path )
    sign_out @admin_user
  end
  
  test "should not destroy call_forward (not an admin)" do
    assert_no_difference('CallForward.count') {
      delete :destroy, :id => @call_forward.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
end
