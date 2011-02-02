require 'test_helper'

class SipUsersControllerTest < ActionController::TestCase
  setup do
    @sip_user = sip_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sip_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sip_user" do
    assert_difference('SipUser.count') do
      post :create, :sip_user => @sip_user.attributes
    end

    assert_redirected_to sip_user_path(assigns(:sip_user))
  end

  test "should show sip_user" do
    get :show, :id => @sip_user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sip_user.to_param
    assert_response :success
  end

  test "should update sip_user" do
    put :update, :id => @sip_user.to_param, :sip_user => @sip_user.attributes
    assert_redirected_to sip_user_path(assigns(:sip_user))
  end

  test "should destroy sip_user" do
    assert_difference('SipUser.count', -1) do
      delete :destroy, :id => @sip_user.to_param
    end

    assert_redirected_to sip_users_path
  end
end
