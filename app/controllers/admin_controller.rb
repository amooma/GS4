class AdminController < ApplicationController
  
  # Let's make sure that we have a database.
  rescue_from ActiveRecord::StatementInvalid, :with => :rescue_missing
  
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  def index
    if NetworkSetting.count == 0
      respond_to do |format|
        format.html { redirect_to(new_network_setting_path) }
      end
    elsif SipServer.count == 0 || SipProxy.count == 0 || VoicemailServer.count == 0
      respond_to do |format|
        format.html { redirect_to(admin_setup_index_path) }
      end
      
    else
      @number_of_users         = User.count
      @number_of_sip_accounts  = SipAccount.count
      @number_of_phones        = Phone.count
      @number_of_sip_proxies   = SipProxy.count
      @number_of_sip_servers   = SipServer.count
      @number_of_extensions    = Extension.count
      @number_of_configurations = Configuration.count
      
      respond_to do |format|
        format.html
      end
    end
  end
  
  def shutdown
    @result = `sudo /sbin/shutdown -h now`
    respond_to do |format|
      format.html
    end
  end

  def reboot
    @result = `sudo /sbin/shutdown -r now`
    respond_to do |format|
      format.html
    end
  end
  
  def help
    respond_to do |format|
      format.html
    end
  end
  
  private
  
  def rescue_missing
    redirect_to( '/db_migrate_missing.html' )
  end
  
end
