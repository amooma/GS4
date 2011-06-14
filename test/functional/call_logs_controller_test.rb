require 'test_helper'

class CallLogsControllerTest < ActionController::TestCase
  setup do
    @call_log = call_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_log" do
    assert_difference('CallLog.count') do
      post :create, :call_log => @call_log.attributes
    end

    assert_redirected_to call_log_path(assigns(:call_log))
  end

  test "should show call_log" do
    get :show, :id => @call_log.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @call_log.to_param
    assert_response :success
  end

  test "should update call_log" do
    put :update, :id => @call_log.to_param, :call_log => @call_log.attributes
    assert_redirected_to call_log_path(assigns(:call_log))
  end

  test "should destroy call_log" do
    assert_difference('CallLog.count', -1) do
      delete :destroy, :id => @call_log.to_param
    end

    assert_redirected_to call_logs_path
  end
end
