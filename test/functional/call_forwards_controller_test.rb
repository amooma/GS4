require 'test_helper'

class CallForwardsControllerTest < ActionController::TestCase
  setup do
    @call_forward = call_forwards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_forwards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_forward" do
    assert_difference('CallForward.count') do
      post :create, :call_forward => @call_forward.attributes
    end

    assert_redirected_to call_forward_path(assigns(:call_forward))
  end

  test "should show call_forward" do
    get :show, :id => @call_forward.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @call_forward.to_param
    assert_response :success
  end

  test "should update call_forward" do
    put :update, :id => @call_forward.to_param, :call_forward => @call_forward.attributes
    assert_redirected_to call_forward_path(assigns(:call_forward))
  end

  test "should destroy call_forward" do
    assert_difference('CallForward.count', -1) do
      delete :destroy, :id => @call_forward.to_param
    end

    assert_redirected_to call_forwards_path
  end
end
