class Admin::SetupController < ApplicationController
  def index
    @User = User.count
  end
  
  def create
    respond_to do |format|
      if User.count == 0      
        @user = User.new(params[:user])
        if @user.save
          format.html { redirect_to(admin_path, :notice => "#{ @user.username } created. You can log in now.") }
          format.xml  { render :xml => admin_path, :status => :created, :location => admin_user_path(@user) }
        else
          format.html { render :action => 'new' }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity}
        end
      else
        format.html { redirect_to(admin_path, :notice => "Setup disabled. Allready done!") }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def new
  end
  
end
