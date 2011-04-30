require 'test_helper'

class NodesControllerTest < ActionController::TestCase
	
	# Devise Test Helpers
	# see https://github.com/plataformatec/devise
	include Devise::TestHelpers
	
	setup do
		@node = Factory.create(:node)
		
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
		assert_not_nil( assigns(:nodes))
		sign_out @admin_user
	end
	
	test "should not get index (not an admin)" do
		get :index
		assert_response( @expected_http_status_if_not_allowed )
	end
	
	
#	test "should get new" do
#		sign_in :user, @admin_user
#		get :new
#		assert_response :success
#		sign_out @admin_user
#	end
#	
#	test "should not get new (not an admin)" do
#		get :new
#		assert_response( @expected_http_status_if_not_allowed )
#	end
	
	test "should not have a route for \"new\" yet" do
		assert_raise( ActionController::RoutingError ) {
			get :new
		}
	end
	
	
#	test "should create node" do
#		sign_in :user, @admin_user
#		assert_difference( 'Node.count' ) {
#			post :create, :node => @node.attributes
#		}
#		assert_redirected_to( node_path( assigns(:node)))
#		sign_out @admin_user
#	end
#	
#	test "should not create node (not an admin) - version a1" do
#		assert_no_difference( 'Node.count' ) {
#			post :create, :node => @node.attributes
#		}
#		assert_response( @expected_http_status_if_not_allowed )
#	end
#	
#	test "should not create node (not an admin) - version a2" do
#		assert_no_difference( 'Node.count' ) {
#			post :create, :node => @node.attributes.reject{ |k,v| k.to_s == 'id' }
#		}
#		assert_response( @expected_http_status_if_not_allowed )
#	end
#	
#	test "should not create node (not an admin) - version b" do
#		assert_no_difference( 'Node.count' ) {
#			node = Factory.build(:node)
#			post :create, :node => node.attributes
#		}
#		assert_response( @expected_http_status_if_not_allowed )
#	end
	
	test "should not have a route for \"create\" yet" do
		assert_raise( ActionController::RoutingError ) {
			post :create, :node => @node.attributes
		}
	end
	
	
	
	test "should show node" do
		sign_in :user, @admin_user
		get :show, :id => @node.to_param
		assert_response :success
		sign_out @admin_user
	end
	
	test "should not show node (not an admin)" do
		get :show, :id => @node.to_param
		assert_response( @expected_http_status_if_not_allowed )
	end
	
	
#	test "should get edit" do
#		sign_in :user, @admin_user
#		get :edit, :id => @node.to_param
#		assert_response :success
#		sign_out @admin_user
#	end
#	
#	test "should not get edit (not an admin)" do
#		get :edit, :id => @node.to_param
#		assert_response( @expected_http_status_if_not_allowed )
#	end
	
	test "should not have a route for \"edit\" yet" do
		assert_raise( ActionController::RoutingError ) {
			get :edit, :id => @node.to_param
		}
	end
	
	
#	test "should update node" do
#		sign_in :user, @admin_user
#		put :update, :id => @node.to_param, :node => @node.attributes
#		assert_redirected_to( node_path( assigns(:node)))
#		sign_out @admin_user
#	end
#	
#	test "should not update node (not an admin) - version a1" do
#		put :update, :id => @node.to_param, :node => @node.attributes.reject{ |k,v| k.to_s == 'id' }
#		assert_response( @expected_http_status_if_not_allowed )
#	end
#	
#	test "should not update node (not an admin) - version a2" do
#		put :update, :id => @node.to_param, :node => @node.attributes
#		assert_response( @expected_http_status_if_not_allowed )
#	end
	
	test "should not have a route for \"update\" yet" do
		assert_raise( ActionController::RoutingError ) {
			put :update, :id => @node.to_param, :node => @node.attributes
		}
	end
	
	
#	test "should destroy node" do
#		sign_in :user, @admin_user
#		assert_difference( 'Node.count', -1 ) {
#			delete :destroy, :id => @node.to_param
#		}
#		assert_redirected_to( nodes_path )
#		sign_out @admin_user
#	end
#	
#	test "should not destroy node (not an admin)" do
#		assert_no_difference( 'SipAccount.count' ) {
#			delete :destroy, :id => @node.to_param
#		}
#		assert_response( @expected_http_status_if_not_allowed )
#	end
	
	test "should not have a route for \"destroy\" yet" do
		assert_raise( ActionController::RoutingError ) {
			delete :destroy, :id => @node.to_param
		}
	end
	
	
end
