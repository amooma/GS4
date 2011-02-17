require 'test_helper'

class Admin::UserControllerTest < ActionController::TestCase
  setup do
    @user = Factory.create(:user)
  end
  
  test "should get index" do
    sign_in :user, @user
    get :index
    assert_response :success
  end

  test "should get show" do
    sign_in :user, @user
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get new" do
    sign_in :user, @user
    get :new
    assert_response :success
  end

  test "should get create" do
    sign_in :user, @user
    get :create
    assert_response :success
  end

  test "should get edit" do
    sign_in :user, @user
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should get update" do
    sign_in :user, @user
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to admin_user_index_path
  end

end
