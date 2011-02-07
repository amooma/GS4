require 'test_helper'

class ProvisioningServersControllerTest < ActionController::TestCase
  setup do
    @provisioning_server = provisioning_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:provisioning_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create provisioning_server" do
    assert_difference('ProvisioningServer.count') do
      post :create, :provisioning_server => @provisioning_server.attributes
    end

    assert_redirected_to provisioning_server_path(assigns(:provisioning_server))
  end

  test "should show provisioning_server" do
    get :show, :id => @provisioning_server.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @provisioning_server.to_param
    assert_response :success
  end

  test "should update provisioning_server" do
    put :update, :id => @provisioning_server.to_param, :provisioning_server => @provisioning_server.attributes
    assert_redirected_to provisioning_server_path(assigns(:provisioning_server))
  end

  test "should destroy provisioning_server" do
    assert_difference('ProvisioningServer.count', -1) do
      delete :destroy, :id => @provisioning_server.to_param
    end

    assert_redirected_to provisioning_servers_path
  end
end
