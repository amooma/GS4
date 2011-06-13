require 'test_helper'

class VoicemailServersControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @voicemail_server = Factory.create( :voicemail_server )
    
    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
    
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
  end
  
  test "should get index" do
    sign_in :user, @admin_user
    get :index
    assert_response :success
    assert_not_nil assigns(:voicemail_servers)
    sign_out @admin_user
  end
  
  test "should not get index (not an admin)" do
    get :index
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get new (not an admin)" do
    get :new
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should create voicemail_server" do
    sign_in :user, @admin_user
    assert_difference('VoicemailServer.count') {
      post :create, :voicemail_server => Factory.attributes_for(:voicemail_server)
    }
    assert_redirected_to( voicemail_server_path( assigns(:voicemail_server)))
    sign_out @admin_user
  end
  
  test "should not create voicemail_server (not an admin)" do
    assert_no_difference('VoicemailServer.count') {
      post :create, :voicemail_server => Factory.attributes_for(:voicemail_server)
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show voicemail_server" do
    sign_in :user, @admin_user
    get :show, :id => @voicemail_server.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show voicemail_server (not an admin)" do
    get :show, :id => @voicemail_server.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @voicemail_server.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @voicemail_server.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update voicemail_server" do
    sign_in :user, @admin_user
    put :update, :id => @voicemail_server.to_param, :voicemail_server => @voicemail_server.attributes
    assert_redirected_to( voicemail_server_path( assigns(:voicemail_server)))
    sign_out @admin_user
  end
  
  test "should not update voicemail_server (not an admin)" do
    put :update, :id => @voicemail_server.to_param, :voicemail_server => @voicemail_server.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy voicemail_server" do
    sign_in :user, @admin_user
    assert_difference('VoicemailServer.count', -1) {
      delete :destroy, :id => @voicemail_server.to_param
    }
    assert_redirected_to( voicemail_servers_path )
    sign_out @admin_user
  end
  
  test "should not destroy voicemail_server (not an admin)" do
    assert_no_difference('VoicemailServer.count') {
      delete :destroy, :id => @voicemail_server.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
end
