require 'test_helper'

class SubscribersControllerTest < ActionController::TestCase
  
  setup do
    @subscriber = Factory.create(:subscriber)
    
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
    assert_not_nil assigns(:subscribers)
    sign_out @admin_user
  end
  
  test "should not get index (not an admin)" do
    get :index
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show subscriber" do
    sign_in :user, @admin_user
    get :show, :id => @subscriber.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show subscriber (not an admin)" do
    get :show, :id => @subscriber.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
end
