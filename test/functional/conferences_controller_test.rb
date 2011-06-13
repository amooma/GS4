require 'test_helper'

class ConferencesControllerTest < ActionController::TestCase
  
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @conference = Factory.create( :conference )
    
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
    assert_not_nil assigns(:conferences)
    sign_out @admin_user
  end
  
  test "should not get index (not an admin)" do
    get :index
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get new" do
    sign_in :user, @admin_user
    get :new
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get new (not an admin)" do
    get :new
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should create conference" do
    sign_in :user, @admin_user
    assert_difference('Conference.count') {
      post :create, :conference => Factory.attributes_for(:conference)
    }
    assert_redirected_to( conference_path( assigns(:conference)))
    sign_out @admin_user
  end
  
  test "should not create conference (not an admin)" do
    assert_no_difference('Conference.count') {
      post :create, :conference => Factory.attributes_for(:conference)
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should show conference" do
    sign_in :user, @admin_user
    get :show, :id => @conference.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not show conference (not an admin)" do
    get :show, :id => @conference.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should get edit" do
    sign_in :user, @admin_user
    get :edit, :id => @conference.to_param
    assert_response :success
    sign_out @admin_user
  end
  
  test "should not get edit (not an admin)" do
    get :edit, :id => @conference.to_param
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should update conference" do
    sign_in :user, @admin_user
    put :update, :id => @conference.to_param, :conference => @conference.attributes
    assert_redirected_to( conference_path( assigns(:conference)))
    sign_out @admin_user
  end
  
  test "should not update conference (not an admin)" do
    put :update, :id => @conference.to_param, :conference => @conference.attributes
    assert_response( @expected_http_status_if_not_allowed )
  end
  
  
  test "should destroy conference" do
    sign_in :user, @admin_user
    assert_difference('Conference.count', -1) {
      delete :destroy, :id => @conference.to_param
    }
    assert_redirected_to( conferences_path )
    sign_out @admin_user
  end
  
  test "should not destroy conference (not an admin)" do
    assert_no_difference('Conference.count') {
      delete :destroy, :id => @conference.to_param
    }
    assert_response( @expected_http_status_if_not_allowed )
  end
  
end
