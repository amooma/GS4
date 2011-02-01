require 'test_helper'

class UserToSipAccountsControllerTest < ActionController::TestCase
  setup do
    @user_to_sip_account = user_to_sip_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_to_sip_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_to_sip_account" do
    assert_difference('UserToSipAccount.count') do
      post :create, :user_to_sip_account => @user_to_sip_account.attributes
    end

    assert_redirected_to user_to_sip_account_path(assigns(:user_to_sip_account))
  end

  test "should show user_to_sip_account" do
    get :show, :id => @user_to_sip_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user_to_sip_account.to_param
    assert_response :success
  end

  test "should update user_to_sip_account" do
    put :update, :id => @user_to_sip_account.to_param, :user_to_sip_account => @user_to_sip_account.attributes
    assert_redirected_to user_to_sip_account_path(assigns(:user_to_sip_account))
  end

  test "should destroy user_to_sip_account" do
    assert_difference('UserToSipAccount.count', -1) do
      delete :destroy, :id => @user_to_sip_account.to_param
    end

    assert_redirected_to user_to_sip_accounts_path
  end
end
