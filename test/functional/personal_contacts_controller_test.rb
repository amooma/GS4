require 'test_helper'

class PersonalContactsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @personal_contact = personal_contacts(:one)

    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
    @personal_contact.user_id = @admin_user.id
    
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
  end

  test "should get index" do
    sign_in :user, @admin_user
    get :index
    assert_response :success
    assert_not_nil assigns(:personal_contacts)
    sign_out @admin_user
  end

  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end

  test "should create personal_contact" do
    sign_in :user, @admin_user
    assert_difference('PersonalContact.count') do
      post :create, :personal_contact => @personal_contact.attributes
    end
    assert_redirected_to personal_contact_path(assigns(:personal_contact))
    sign_out @admin_user
  end

  test "should show personal_contact" do
    sign_in :user, @admin_user
    get :show, :id => @personal_contact.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @personal_contact.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should update personal_contact" do
    sign_in :user, @admin_user
    put :update, :id => @personal_contact.to_param, :personal_contact => @personal_contact.attributes
    assert_redirected_to personal_contact_path(assigns(:personal_contact))
    sign_out @admin_user
  end

  test "should destroy personal_contact" do
    sign_in :user, @admin_user
    assert_difference('PersonalContact.count', -1) do
      delete :destroy, :id => @personal_contact.to_param
    end
    assert_redirected_to personal_contacts_path
    sign_out @admin_user
  end

end
