require 'test_helper'

class PersonalPhonebooksControllerTest < ActionController::TestCase
 include Devise::TestHelpers
  
  setup do
    @personal_phonebook = personal_phonebooks(:one)

    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
    @personal_phonebook.user_id = @admin_user.id
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
    @expected_http_status_if_no_route = 404
  end
  

  test "should get index" do
    sign_in :user, @admin_user
    get :index
    assert_response :success
    assert_not_nil assigns(:personal_phonebooks)
    sign_out @admin_user
  end

  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end

  test "should create personal_phonebook" do
    assert_difference('PersonalPhonebook.count') do
      sign_in :user, @admin_user
      post :create, :personal_phonebook => @personal_phonebook.attributes
      sign_out @admin_user
    end

    assert_redirected_to personal_phonebook_path(assigns(:personal_phonebook))
  end

  test "should show personal_phonebook" do
    sign_in :user, @admin_user
    get :show, :id => @personal_phonebook.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @personal_phonebook.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should update personal_phonebook" do
    sign_in :user, @admin_user
    put :update, :id => @personal_phonebook.to_param, :personal_phonebook => @personal_phonebook.attributes
    assert_redirected_to personal_phonebook_path(assigns(:personal_phonebook))
    sign_out @admin_user
  end

  test "should destroy personal_phonebook" do
    sign_in :user, @admin_user
    assert_difference('PersonalPhonebook.count', -1) do
      delete :destroy, :id => @personal_phonebook.to_param
    end
    assert_redirected_to personal_phonebooks_path
    sign_out @admin_user
  end
end
