class PagesController < ApplicationController
  rescue_from ActiveRecord::StatementInvalid, :with => :rescue_missing
  
  #before_filter :authenticate_user!
  
  def index
    if User.count == 0 || SipServer.count == 0 || ProvisioningServer.count == 0 || SipProxy.count == 0
      respond_to do |format|
        format.html { redirect_to(admin_setup_index_path) }
      end
    end
    if current_user
      respond_to do |format|
        format.html { redirect_to(admin_index_path) }
      end
    end
  end
  
  private
  def rescue_missing
    redirect_to('/db_migrate_missing')
  end
  
end