require 'test_helper'

class GlobalContactsControllerTest < ActionController::TestCase
 
# Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @global_contact = global_contacts(:one)

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
    assert_not_nil assigns(:global_contacts)
    sign_out @admin_user
  end

  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end

  test "should create global_contact" do
    sign_in :user, @admin_user
    assert_difference('GlobalContact.count') do
      post :create, :global_contact => @global_contact.attributes
    end

    assert_redirected_to global_contact_path(assigns(:global_contact))
    sign_out @admin_user
  end

  test "should show global_contact" do
    sign_in :user, @admin_user
    get :show, :id => @global_contact.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @global_contact.to_param
    assert_response :success
    sign_out @admin_user
  end

  test "should update global_contact" do
    sign_in :user, @admin_user
    put :update, :id => @global_contact.to_param, :global_contact => @global_contact.attributes
    assert_redirected_to global_contact_path(assigns(:global_contact))
    sign_out @admin_user
  end

  test "should destroy global_contact" do
    sign_in :user, @admin_user
    assert_difference('GlobalContact.count', -1) do
      delete :destroy, :id => @global_contact.to_param
    end

    assert_redirected_to global_contacts_path
    sign_out @admin_user
  end

end
