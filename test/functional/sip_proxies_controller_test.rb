require 'test_helper'

class SipProxiesControllerTest < ActionController::TestCase
  setup do
    @sip_proxy = Factory.create(:sip_proxy)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sip_proxies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sip_proxy" do
    assert_difference('SipProxy.count') do
      post :create, :sip_proxy => Factory.attributes_for(:sip_proxy)
    end

    assert_redirected_to sip_proxy_path(assigns(:sip_proxy))
  end

  test "should show sip_proxy" do
    get :show, :id => @sip_proxy.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sip_proxy.to_param
    assert_response :success
  end

  test "should update sip_proxy" do
    put :update, :id => @sip_proxy.to_param, :sip_proxy => @sip_proxy.attributes
    assert_redirected_to sip_proxy_path(assigns(:sip_proxy))
  end

  test "should destroy sip_proxy" do
    assert_difference('SipProxy.count', -1) do
      delete :destroy, :id => @sip_proxy.to_param
    end

    assert_redirected_to sip_proxies_path
  end
end
