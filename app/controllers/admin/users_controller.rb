class Admin::UsersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @users = User.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    respond_to do |format|
      @user = User.new(params[:user])
      if @user.save
        format.html { redirect_to( admin_users_path, :notice => t(:user_created)) }
        format.xml  { render :xml => admin_users_path(@user), :status => :created, :location => admin_users_path(@user) }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to( admin_users_path, :notice => t(:user_updated)) }
        format.xml  { render :xml => admin_users_path(@user), :status => :updated, :location => admin_users_path(@user) }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def delete
  end
  
  def destroy
    @user = User.find(params[:id])
    if params[:cancel]
      redirect_to( admin_users_path )
      return
    end
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to( admin_user_path ) }
        format.xml  { head :ok }
      end
    end
  end
  
end
