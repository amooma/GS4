class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  
  # https://github.com/ryanb/cancan/wiki/Ensure-Authorization
  check_authorization :if => :requires_authorization
  
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
  }
  
  def local_ip
    UDPSocket.open {|s| s.connect("255.255.255.254", 1); s.addr.last }
  end
  
  
  private
  
  
  def requires_authorization
    no_cancan_for_controllers = [
      'sessions',
      'setup',
    ]
    return ! no_cancan_for_controllers.include?( controller_name.to_s.downcase )
  end
  
end
