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
    get :show
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
    get :edit
    assert_response :success
  end

  test "should get update" do
    sign_in :user, @user
    get :update
    assert_response :success
  end

end
