class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  
  # https://github.com/ryanb/cancan/wiki/Ensure-Authorization
  check_authorization :if => :requires_authorization
  before_filter :setup, :only => [ :index, :show ]
  
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied. (Action: #{exception.action}, Resource: #{exception.subject})"
    if ! user_signed_in?
      redirect_to root_url, :alert => exception.message
    else
      render({
        :status => 403,
        :file   => "#{Rails.root}/app/views/403.html.erb",
        :layout => true,
        :locals => { :exception => exception },
    })
    end
  end
    
  before_filter { |controller|
    @app_number_of_users = User.count              
    if @app_number_of_users > 0 && NetworkSetting.count > 0
       @render_top_navigation = true
    end
  }
  
  def guess_local_ip_address
    ret = nil
    begin
      ipsocket_addr_info = UDPSocket.open {|s| s.connect("255.255.255.254", 1); s.addr(false) }
      ret = ipsocket_addr_info.last if ipsocket_addr_info
    rescue
    end
    return ret
  end
  
  def guess_local_host
    ret = guess_local_ip_address
    if ! ret
      begin
        if request
          ret = request.env['SERVER_NAME']
        end
      rescue
      end
    end
    if ret && [
      "",
      "127.0.0.1",
      "localhost",
      "0.0.0.0",
    ].include?(ret)
      ret = nil
    end
    return ret
  end
  
  
  private
  
  def requires_authorization
    no_cancan_for_controllers = [
      'sessions',   # Devise
      #'passwords',  # Devise
      #'setup',
    ]
    return ! no_cancan_for_controllers.include?( controller_name.to_s.downcase )
  end
  
  def setup
    if ::Rails.env == 'production' || ::Rails.env == 'development'
      if User.count == 0
        respond_to do |format|
          format.html { redirect_to( new_admin_setup_path ) }
        end
      elsif NetworkSetting.count == 0
        respond_to do |format|
          format.html { redirect_to( new_network_setting_path ) }
        end
      elsif SipServer.count == 0 || SipProxy.count == 0 || VoicemailServer.count == 0
        respond_to do |format|
          format.html { redirect_to( admin_setup_index_path ) }
        end
      end
    end
  end
  
end
