require 'test_helper'

class PinChangeControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    user_username_1 = 'one'
    @user = User.where( :username => user_username_1 ).first
    @expected_http_status_if_not_allowed = 302
  end
  
  test "should get edit" do
    sign_in :user, @user
    get :edit
    assert_response :success
    sign_out @user
  end
  
  test "should not get edit (not logged in)" do
    get :edit
    assert_response( @expected_http_status_if_not_allowed )
  end
  
end
