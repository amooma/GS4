require 'test_helper'

class UserToPhonesControllerTest < ActionController::TestCase
  setup do
    @user_to_phone = user_to_phones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_to_phones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_to_phone" do
    assert_difference('UserToPhone.count') do
      post :create, :user_to_phone => @user_to_phone.attributes
    end

    assert_redirected_to user_to_phone_path(assigns(:user_to_phone))
  end

  test "should show user_to_phone" do
    get :show, :id => @user_to_phone.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user_to_phone.to_param
    assert_response :success
  end

  test "should update user_to_phone" do
    put :update, :id => @user_to_phone.to_param, :user_to_phone => @user_to_phone.attributes
    assert_redirected_to user_to_phone_path(assigns(:user_to_phone))
  end

  test "should destroy user_to_phone" do
    assert_difference('UserToPhone.count', -1) do
      delete :destroy, :id => @user_to_phone.to_param
    end

    assert_redirected_to user_to_phones_path
  end
end
