require 'test_helper'

class VoicemailServersControllerTest < ActionController::TestCase
  setup do
    @voicemail_server = voicemail_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:voicemail_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create voicemail_server" do
    assert_difference('VoicemailServer.count') do
      post :create, :voicemail_server => @voicemail_server.attributes
    end

    assert_redirected_to voicemail_server_path(assigns(:voicemail_server))
  end

  test "should show voicemail_server" do
    get :show, :id => @voicemail_server.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @voicemail_server.to_param
    assert_response :success
  end

  test "should update voicemail_server" do
    put :update, :id => @voicemail_server.to_param, :voicemail_server => @voicemail_server.attributes
    assert_redirected_to voicemail_server_path(assigns(:voicemail_server))
  end

  test "should destroy voicemail_server" do
    assert_difference('VoicemailServer.count', -1) do
      delete :destroy, :id => @voicemail_server.to_param
    end

    assert_redirected_to voicemail_servers_path
  end
end
