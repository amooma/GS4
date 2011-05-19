class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  before_filter { |controller|
    @app_number_of_users = User.count
  }
  
  def local_ip
    UDPSocket.open {|s| s.connect("255.255.255.254", 1); s.addr.last }
  end
  
end
