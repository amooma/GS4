require 'test_helper'

class CallQueuesControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @call_queue = Factory.create( :call_queue )
    
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
    assert_not_nil assigns(:call_queues)
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
  
  
  test "should create call_queue" do
    sign_in :user, @admin_user
    assert_difference('CallQueue.count') {
      post :create, :call_queue => Factory.attributes_for(:call_queue)
    }
    assert_redirected_to( call_queue_path( assigns(:call_queue)))
    sign_out @admin_user
  end
  
  test "should not create call_queue (not an admin)" do
    assert_no_difference('CallQueue.count') {
      post :create, :call_queue => Factory.attributes_for(:call_queue)
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show call_queue" do
    sign_in :user, @admin_user
    get :show, :id => @call_queue.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show call_queue (not an admin)" do
    get :show, :id => @call_queue.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @call_queue.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @call_queue.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update call_queue" do
    sign_in :user, @admin_user
    put :update, :id => @call_queue.to_param, :call_queue => @call_queue.attributes
    assert_redirected_to( call_queue_path( assigns(:call_queue)))
    sign_out @admin_user
  end
  
  test "should not update call_queue (not an admin)" do
    put :update, :id => @call_queue.to_param, :call_queue => @call_queue.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy call_queue" do
    sign_in :user, @admin_user
    assert_difference('CallQueue.count', -1) {
      delete :destroy, :id => @call_queue.to_param
    }
    assert_redirected_to( call_queues_path )
    sign_out @admin_user
  end
  
  test "should not destroy call_queue (not an admin)" do
    assert_no_difference('CallQueue.count') {
      delete :destroy, :id => @call_queue.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
end
