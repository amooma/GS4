require 'test_helper'

class ExtensionsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @extension = extensions(:one)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil( assigns(:extensions))
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create extension" do
    assert_difference('Extension.count') {
      post :create, :extension => @extension.attributes
    }
    assert_redirected_to( extension_path( assigns(:extension)))
  end
  
  test "should show extension" do
    get :show, :id => @extension.to_param
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => @extension.to_param
    assert_response :success
  end
  
  test "should update extension" do
    put :update, :id => @extension.to_param, :extension => @extension.attributes
    assert_redirected_to( extension_path( assigns(:extension)))
  end
  
  test "should destroy extension" do
    assert_difference('Extension.count', -1) {
      delete :destroy, :id => @extension.to_param
    }
    assert_redirected_to( extensions_path )
  end
  
end
