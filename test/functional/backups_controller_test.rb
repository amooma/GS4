require 'test_helper'

class BackupsControllerTest < ActionController::TestCase
  setup do
    @backup = backups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:backups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create backup" do
    assert_difference('Backup.count') do
      post :create, :backup => @backup.attributes
    end

    assert_redirected_to backup_path(assigns(:backup))
  end

  test "should show backup" do
    get :show, :id => @backup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @backup.to_param
    assert_response :success
  end

  test "should update backup" do
    put :update, :id => @backup.to_param, :backup => @backup.attributes
    assert_redirected_to backup_path(assigns(:backup))
  end

  test "should destroy backup" do
    assert_difference('Backup.count', -1) do
      delete :destroy, :id => @backup.to_param
    end

    assert_redirected_to backups_path
  end
end
