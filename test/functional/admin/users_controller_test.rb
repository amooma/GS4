require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @user = Factory.create(:user)
    
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
  
  test "should get index (admin)" do
    sign_in :user, @admin_user
    get :index
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get index (not logged in)" do
    get :index
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  
  test "should not get show (normal user)" do
    sign_in :user, @user_user
    get :show, :id => @user.to_param
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @user_user
  end
  
  test "should not get show (CDR admin)" do
    sign_in :user, @cdr_user
    get :show, :id => @user.to_param
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @cdr_user
  end
  
  test "should get show (admin)" do
    sign_in :user, @admin_user
    get :show, :id => @user.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get show (not logged in)" do
    get :show, :id => @user.to_param
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  
  test "should not get new (normal user)" do
    sign_in :user, @user_user
    get :new
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @user_user
  end
  
  test "should not get new (CDR admin)" do
    sign_in :user, @cdr_user
    get :new
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @cdr_user
  end
  
  test "should get new (admin)" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get new (not logged in)" do
    get :new
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  
  test "should not get create (normal user)" do
    sign_in :user, @user_user
    get :create
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @user_user
  end
  
  test "should not get create (CDR admin)" do
    sign_in :user, @cdr_user
    get :create
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @cdr_user
  end
  
  test "should get create (admin)" do
    sign_in :user, @admin_user
    get :create
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get create (not logged in)" do
    get :create
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  
  test "should not get edit (normal user)" do
    sign_in :user, @user_user
    get :edit, :id => @user.to_param
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @user_user
  end
  
  test "should not get edit (CDR admin)" do
    sign_in :user, @cdr_user
    get :edit, :id => @user.to_param
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @cdr_user
  end
  
  test "should get edit (admin)" do
    sign_in :user, @admin_user
    get :edit, :id => @user.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not logged in)" do
    get :edit, :id => @user.to_param
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  
  test "should not update (normal user)" do
    sign_in :user, @user_user
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @user_user
  end
  
  test "should not update (CDR admin)" do
    sign_in :user, @cdr_user
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_response( @expected_http_status_if_not_allowed )
    sign_out @cdr_user
  end
  
  #test "should update (admin)" do
  #  sign_in :user, @admin_user
  #  put :update, :id => @user.to_param, :user => @user.attributes
  #  assert_response 302  #OPTIMIZE
  #  #assert_redirected_to( admin_users_path( assigns(:user)))
  #  sign_out @admin_user
  #end
  
  test "should not update (not logged in)" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_response( @expected_http_status_if_not_signed_in )
  end
  
  
  
end
