require 'test_helper'

#OPTIMIZE Find good tests for fax documents.

class FaxDocumentsControllerTest < ActionController::TestCase
    
  # Devise Test Helpers
  # see https://github.com/plataformatec/devise
  include Devise::TestHelpers
  
  setup do
    @fax_document = Factory.create( :fax_document )
    
    an_admin_username = 'admin1'
    @admin_user = User.where( :username => an_admin_username ).first
    assert_not_nil( @admin_user, "This tests needs user #{an_admin_username.inspect}" )
    
    #@expected_http_status_if_not_allowed = 403
    @expected_http_status_if_not_allowed = 302
  end
  
#  test "should get index" do
#    sign_in :user, @admin_user
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:fax_documents)
#    sign_out @admin_user
#  end
  
#  test "should not get index (not an admin)" do
#    get :index
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
  
#  test "should get new" do
#    sign_in :user, @admin_user
#    get :new
#    assert_response :success
#    sign_out @admin_user
#  end
  
#  test "should not get new (not an admin)" do
#    get :new
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
  
#  test "should create fax_document" do
#    sign_in :user, @admin_user
#    assert_difference('FaxDocument.count') {
#      post :create, :fax_document => Factory.attributes_for(:fax_document)
#    }
#    assert_redirected_to( fax_document_path( assigns(:fax_document)))
#    sign_out @admin_user
#  end
  
#  test "should not create fax_document (not an admin)" do
#    assert_no_difference('FaxDocument.count') {
#      post :create, :fax_document => Factory.attributes_for(:fax_document)
#    }
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
  
#  test "should show fax_document" do
#    sign_in :user, @admin_user
#    get :show, :id => @fax_document.to_param
#    assert_response :success
#    sign_out @admin_user
#  end
  
#  test "should not show fax_document (not an admin)" do
#    get :show, :id => @fax_document.to_param
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
  
#  test "should get edit" do
#    sign_in :user, @admin_user
#    get :edit, :id => @fax_document.to_param
#    assert_response :success
#    sign_out @admin_user
#  end
  
#  test "should not get edit (not an admin)" do
#    get :edit, :id => @fax_document.to_param
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
  
#  test "should update fax_document" do
#    sign_in :user, @admin_user
#    put :update, :id => @fax_document.to_param, :fax_document => @fax_document.attributes
#    assert_redirected_to( fax_document_path( assigns(:fax_document)))
#    sign_out @admin_user
#  end
  
#  test "should not update fax_document (not an admin)" do
#    put :update, :id => @fax_document.to_param, :fax_document => @fax_document.attributes
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
  
#  test "should destroy fax_document" do
#    sign_in :user, @admin_user
#    assert_difference('FaxDocument.count', -1) {
#      delete :destroy, :id => @fax_document.to_param
#    }
#    assert_redirected_to( fax_documents_path )
#    sign_out @admin_user
#  end
  
#  test "should not destroy fax_document (not an admin)" do
#    assert_no_difference('FaxDocument.count') {
#      delete :destroy, :id => @fax_document.to_param
#    }
#    assert_response( @expected_http_status_if_not_allowed )
#  end
  
end
