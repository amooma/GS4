require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase
  setup do
    @subscriber = Factory.create(:subscriber) 
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subscribers)
  end

  test "should show subscriber" do
    get :show, :id => @subscriber.to_param
    assert_response :success
  end
end
