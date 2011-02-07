require 'test_helper'

class SipAccountsControllerTest < ActionController::TestCase
  setup do
    @sip_account = sip_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sip_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sip_account" do
    assert_difference('SipAccount.count') do
      post :create, :sip_account => @sip_account.attributes
    end

    assert_redirected_to sip_account_path(assigns(:sip_account))
  end

  test "should show sip_account" do
    get :show, :id => @sip_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sip_account.to_param
    assert_response :success
  end

  test "should update sip_account" do
    put :update, :id => @sip_account.to_param, :sip_account => @sip_account.attributes
    assert_redirected_to sip_account_path(assigns(:sip_account))
  end

  test "should destroy sip_account" do
    assert_difference('SipAccount.count', -1) do
      delete :destroy, :id => @sip_account.to_param
    end

    assert_redirected_to sip_accounts_path
  end
end
