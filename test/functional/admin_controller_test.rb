require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @sip_server = Factory.create(:sip_server)
    @provisioning_server = Factory.create(:provisioning_server)
    @user = Factory.create(:user)
    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
  end
  
  test "should get index" do
    sign_in :user, @admin_user 
    get :index 
    assert_response :success
  end
  
end
