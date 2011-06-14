require 'test_helper'

class CallLogsControllerTest < ActionController::TestCase
  setup do
    @call_log = call_logs(:one)
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
    assert_not_nil assigns(:call_logs)
    sign_out @admin_user
  end

  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end

  test "should create call_log" do
    sign_in :user, @admin_user
    assert_difference('CallLog.count') do
      post :create, :call_log => @call_log.attributes
    end

    assert_redirected_to call_log_path(assigns(:call_log))
    sign_out @admin_user
  end

  test "should show call_log" do
    sign_in :user, @admin_user
    get :show, :id => @call_log.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @call_log.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should update call_log" do
    sign_in :user, @admin_user
    put :update, :id => @call_log.to_param, :call_log => @call_log.attributes
    assert_redirected_to call_log_path(assigns(:call_log))
    sign_out @admin_user
  end

  test "should destroy call_log" do
    sign_in :user, @admin_user
    assert_difference('CallLog.count', -1) do
      delete :destroy, :id => @call_log.to_param
    end

    assert_redirected_to call_logs_path
    sign_out @admin_user
  end
end
