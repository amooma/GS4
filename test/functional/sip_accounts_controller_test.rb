require 'test_helper'

class SipAccountsControllerTest < ActionController::TestCase
  
  setup do
    @sip_account = sip_accounts(:one)
    
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
    assert_not_nil( assigns(:sip_accounts))
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
  
  
  test "should create sip_account" do
    sign_in :user, @admin_user
    assert_difference('SipAccount.count') {
      post :create, :sip_account => @sip_account.attributes
    }
    assert_redirected_to( sip_account_path( assigns(:sip_account)))
    sign_out @admin_user
  end
  
  test "should not create sip_account (not an admin)" do
    assert_no_difference('SipAccount.count') {
      post :create, :sip_account => @sip_account.attributes
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show sip_account" do
    sign_in :user, @admin_user
    get :show, :id => @sip_account.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show sip_account (not an admin)" do
    get :show, :id => @sip_account.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @sip_account.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @sip_account.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update sip_account" do
    sign_in :user, @admin_user
    put :update, :id => @sip_account.to_param, :sip_account => @sip_account.attributes
    assert_redirected_to( sip_account_path( assigns(:sip_account)))
    sign_out @admin_user
  end
  
  test "should not update sip_account (not an admin)" do
    put :update, :id => @sip_account.to_param, :sip_account => @sip_account.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy sip_account" do
    sign_in :user, @admin_user
    assert_difference('SipAccount.count', -1) {
      delete :destroy, :id => @sip_account.to_param
    }
    assert_redirected_to( sip_accounts_path )
    sign_out @admin_user
  end
  
  test "should not destroy sip_account (not an admin)" do
    assert_no_difference('SipAccount.count') {
      delete :destroy, :id => @sip_account.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
end
