require 'test_helper'

class CallLogsControllerTest < ActionController::TestCase
	
	# Devise Test Helpers
	# see https://github.com/plataformatec/devise
	include Devise::TestHelpers
	
	setup do
		@call_log = Factory.create( :call_log )
		
		admin_username_1 = 'admin1'
		@admin_user = User.where( :username => admin_username_1 ).first
		assert_not_nil( @admin_user, "This tests needs user #{admin_username_1.inspect}" )
		
		cdr_username_1 = 'cdr1'
		@cdr_user = User.where( :username => cdr_username_1 ).first
		assert_not_nil( @cdr_user, "This tests needs user #{cdr_username_1.inspect}" )
		
		user_username_1 = 'one'
		@user_user = User.where( :username => user_username_1 ).first
		assert_not_nil( @user_user, "This tests needs user #{user_username_1.inspect}" )
		
		@expected_http_status_if_not_allowed = 403
		@expected_http_status_if_not_signed_in = 302
		#@expected_http_status_if_no_route = 404
	end
	
	
	
	
	
	test "should get index (of their own call logs) (normal user)" do
		sign_in :user, @user_user
		get :index
		assert_response :success
		assert_not_nil assigns(:call_logs)
		sign_out @user_user
	end
	
	test "should not get index (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		get :index
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not get index (not logged in)" do
		get :index
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
	
	test "should not get new (not even CDR admins can create call logs)" do
		sign_in :user, @cdr_user
		get :new
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @cdr_user
	end
	
	test "should not get new (normal user)" do
		sign_in :user, @user_user
		get :new
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @user_user
	end
	
	test "should not get new (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		get :new
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not get new (not logged in)" do
		get :new
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
	
	test "should not create call_log (not even CDR admins can create call logs)" do
		sign_in :user, @cdr_user
		assert_no_difference('CallLog.count') {
			post :create, :call_log => Factory.attributes_for(:call_log)
		}
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @cdr_user
	end
	
	test "should not create call_log (normal user)" do
		sign_in :user, @user_user
		assert_no_difference('CallLog.count') {
			post :create, :call_log => Factory.attributes_for(:call_log)
		}
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @user_user
	end
	
	test "should not create call_log (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		assert_no_difference('CallLog.count') {
			post :create, :call_log => Factory.attributes_for(:call_log)
		}
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not create call_log (not logged in)" do
		assert_no_difference('CallLog.count') {
			post :create, :call_log => Factory.attributes_for(:call_log)
		}
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
	
	test "should not show call_log (CDR admin)" do
		sign_in :user, @cdr_user
		get :show, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @cdr_user
	end
	
	test "should not show call_log (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		get :show, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not show call_log (not logged in)" do
		get :show, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
	
	test "should not get edit (not even CDR admins can edit call logs)" do
		sign_in :user, @cdr_user
		get :edit, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @cdr_user
	end
	
	test "should not get edit (normal user)" do
		sign_in :user, @user_user
		get :edit, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @user_user
	end
	
	test "should not get edit (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		get :edit, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not get edit (not logged in)" do
		get :edit, :id => @call_log.to_param
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
	
	test "should not update call_log (not even CDR admins can edit call logs)" do
		sign_in :user, @cdr_user
		put :update, :id => @call_log.to_param, :call_log => @call_log.attributes
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @cdr_user
	end
	
	test "should not update call_log (normal user)" do
		sign_in :user, @user_user
		put :update, :id => @call_log.to_param, :call_log => @call_log.attributes
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @user_user
	end
	
	test "should not update call_log (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		put :update, :id => @call_log.to_param, :call_log => @call_log.attributes
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not update call_log (not logged in)" do
		put :update, :id => @call_log.to_param, :call_log => @call_log.attributes
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
	
	test "should not destroy call_log (not even CDR admins can destroy call logs)" do
		sign_in :user, @cdr_user
		assert_no_difference('CallLog.count') {
			delete :destroy, :id => @call_log.to_param
		}
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @cdr_user
	end
	
	test "should not destroy call_log (normal user)" do
		sign_in :user, @user_user
		assert_no_difference('CallLog.count') {
			delete :destroy, :id => @call_log.to_param
		}
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @user_user
	end
	
	test "should not destroy call_log (not a CDR admin but admin)" do
		sign_in :user, @admin_user
		assert_no_difference('CallLog.count') {
			delete :destroy, :id => @call_log.to_param
		}
		assert_response( @expected_http_status_if_not_allowed )
		sign_out @admin_user
	end
	
	test "should not destroy call_log (not logged in)" do
		assert_no_difference('CallLog.count') {
			delete :destroy, :id => @call_log.to_param
		}
		assert_response( @expected_http_status_if_not_signed_in )
	end
	
	
end
