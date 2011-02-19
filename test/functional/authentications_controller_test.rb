require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @authentication = Factory.create(:authentication)
    #@authentication = authentications(:one)
    @user = Factory.create(:user)
    #sign_in(@user)
    
  end
  
  
  test "should get index" do
    sign_in(@user)
    get :index
    assert_response :success
    assert_not_nil( assigns(:authentications))
    sign_out(@user)
  end
  
# TODO FIX create and destroy
# not needed yet
  #test "should create authentication" do
  #  sign_in(@user)
  #  assert_difference('Authentication.count') {
  #    post :create, :authentication => @authentication.attributes
  #  }
  #  assert_redirected_to( authentication_path( assigns(:authentication)))
  #  sign_out(:user)
  #end
  #
  #test "should destroy authentication" do
  #  sign_in(:user)
  #  assert_difference('Authentication.count', -1) {
  #    delete :destroy, :id => @authentication.to_param
  #  }
  #  assert_redirected_to( authentications_path )
  #  sign_out(:user)
  #end
  
  
end
