require 'test_helper'

class SipServersControllerTest < ActionController::TestCase
  setup do
    @sip_server = sip_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sip_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sip_server" do
    assert_difference('SipServer.count') do
      post :create, :sip_server => @sip_server.attributes
    end

    assert_redirected_to sip_server_path(assigns(:sip_server))
  end

  test "should show sip_server" do
    get :show, :id => @sip_server.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sip_server.to_param
    assert_response :success
  end

  test "should update sip_server" do
    put :update, :id => @sip_server.to_param, :sip_server => @sip_server.attributes
    assert_redirected_to sip_server_path(assigns(:sip_server))
  end

  test "should destroy sip_server" do
    assert_difference('SipServer.count', -1) do
      delete :destroy, :id => @sip_server.to_param
    end

    assert_redirected_to sip_servers_path
  end
end
