class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter { |controller|
    @app_number_of_users = User.count
  }
  
end
