class Admin::SetupController < ApplicationController
  def index
    @User = User.count
  end
  
  def create
    respond_to do |format|
      if User.count == 0      
        @user = User.new(params[:user])
        if @user.save
          format.html { redirect_to(admin_index_path, :notice => "#{ @user.username } created. You can log in now.") }
        else
          format.html { render :action => 'new' }
        end
      else
        format.html { redirect_to(admin_index_path, :notice => "Setup disabled. Already done!") }
      end
    end
  end
  
  def new
  end
  
end
