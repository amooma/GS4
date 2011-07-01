require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @authentication = Factory.create(:authentication)
    
    admin_username_1 = 'admin1'
    @admin_user = User.where( :username => admin_username_1 ).first
    assert_not_nil( @admin_user, "This tests needs user #{admin_username_1.inspect}" )
    
    cdr_username_1 = 'cdr1'
    @cdr_user = User.where( :username => cdr_username_1 ).first
    assert_not_nil( @cdr_user, "This tests needs user #{cdr_username_1.inspect}" )
    
    user_username_1 = 'one'
    @user_user = User.where( :username => user_username_1 ).first
    assert_not_nil( @user_user, "This tests needs user #{user_username_1.inspect}" )
    
    @expected_http_status_if_not_allowed = 403
	@expected_http_status_if_not_signed_in = 302
  end
  
  
  test "should not get index (normal user)" do
    sign_in :user, @user_user
    get :index
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @user_user
  end
  
  test "should not get index (CDR admin)" do
    sign_in :user, @cdr_user
    get :index
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @cdr_user
  end
  
  test "should not get index (admin)" do
    sign_in :user, @admin_user
    get :index
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @admin_user
  end
  
  test "should not get index (not logged in)" do
    get :index
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  # not needed yet:
  #test "should create authentication" do
  #  sign_in(@user)
  #  assert_difference('Authentication.count') {
  #    post :create, :authentication => @authentication.attributes
  #  }
  #  assert_redirected_to( authentication_path( assigns(:authentication)))
  #  sign_out(@user)
  #end
  #
  #test "should destroy authentication" do
  #  sign_in(@user)
  #  assert_difference('Authentication.count', -1) {
  #    delete :destroy, :id => @authentication.to_param
  #  }
  #  assert_redirected_to( authentications_path )
  #  sign_out(@user)
  #end
  
end
