require 'test_helper'

class SipPhonesControllerTest < ActionController::TestCase
  setup do
    @sip_phone = sip_phones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sip_phones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sip_phone" do
    assert_difference('SipPhone.count') do
      post :create, :sip_phone => @sip_phone.attributes
    end

    assert_redirected_to sip_phone_path(assigns(:sip_phone))
  end

  test "should show sip_phone" do
    get :show, :id => @sip_phone.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sip_phone.to_param
    assert_response :success
  end

  test "should update sip_phone" do
    put :update, :id => @sip_phone.to_param, :sip_phone => @sip_phone.attributes
    assert_redirected_to sip_phone_path(assigns(:sip_phone))
  end

  test "should destroy sip_phone" do
    assert_difference('SipPhone.count', -1) do
      delete :destroy, :id => @sip_phone.to_param
    end

    assert_redirected_to sip_phones_path
  end
end
