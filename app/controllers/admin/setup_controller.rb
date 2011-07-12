class Admin::SetupController < ApplicationController
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  authorize_resource :class => :Setup
  
  def index
    #@User = User.accessible_by( current_ability, :index ).count
  end
  
  def create
    respond_to do |format|
      if User.count == 0      
        @user = User.new(params[:user])
        if @user.save
          format.html { redirect_to(admin_index_path, :notice => t(:user_name_created_login, :user_name => @user.username )) }
        else
          format.html { render :action => 'new' }
        end
      else
        format.html { redirect_to(admin_index_path, :notice => t(:setup_disabled_done)) }
      end
    end
  end
  
  def new
    @user = User.new
    @user.role = "admin"
  end
  
end
