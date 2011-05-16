require 'test_helper'

class CallQueuesControllerTest < ActionController::TestCase
  setup do
    @call_queue = call_queues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:call_queues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create call_queue" do
    assert_difference('CallQueue.count') do
      post :create, :call_queue => @call_queue.attributes
    end

    assert_redirected_to call_queue_path(assigns(:call_queue))
  end

  test "should show call_queue" do
    get :show, :id => @call_queue.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @call_queue.to_param
    assert_response :success
  end

  test "should update call_queue" do
    put :update, :id => @call_queue.to_param, :call_queue => @call_queue.attributes
    assert_redirected_to call_queue_path(assigns(:call_queue))
  end

  test "should destroy call_queue" do
    assert_difference('CallQueue.count', -1) do
      delete :destroy, :id => @call_queue.to_param
    end

    assert_redirected_to call_queues_path
  end
end
