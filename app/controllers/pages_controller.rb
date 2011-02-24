class PagesController < ApplicationController
  rescue_from ActiveRecord::StatementInvalid, :with => :rescue_missing
  
  #before_filter :authenticate_user!
  
  def index

      respond_to do |format|
    	if User.count == 0 || SipServer.count == 0 || ProvisioningServer.count == 0 || SipProxy.count == 0
	    format.html { redirect_to(admin_setup_index_path) }
	else
            format.html { redirect_to(admin_index_path) }
      end
    end
  end
  private
  def rescue_missing
    redirect_to('/db_migrate_missing')
  end
  
end
