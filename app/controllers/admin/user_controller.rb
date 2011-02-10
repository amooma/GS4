class Admin::UserController < ApplicationController
 
  def index
    @users = User.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def new
#    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "#{ @user.username } created."
      redirect_to admin_user_index_path
    else
      render :action => 'new'
    end
  end

  def edit
        @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User."
      redirect_to admin_user_index_path
    else
      render :action => 'edit'
    end
  end

  def delete
  end

  def destroy
    @user = User.find(params[:id])
    redirect_to admin_user_index_path and return if params[:cancel]
    if @user.destroy
      flash[:notice] = "#{ @user.username } deleted."
      redirect_to admin_user_index_path
    end
  end


end
