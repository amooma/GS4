class UserToSipAccountsController < ApplicationController
  # GET /user_to_sip_accounts
  # GET /user_to_sip_accounts.xml
  def index
    @user_to_sip_accounts = UserToSipAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_to_sip_accounts }
    end
  end

  # GET /user_to_sip_accounts/1
  # GET /user_to_sip_accounts/1.xml
  def show
    @user_to_sip_account = UserToSipAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_to_sip_account }
    end
  end

  # GET /user_to_sip_accounts/new
  # GET /user_to_sip_accounts/new.xml
  def new
    @user_to_sip_account = UserToSipAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_to_sip_account }
    end
  end

  # GET /user_to_sip_accounts/1/edit
  def edit
    @user_to_sip_account = UserToSipAccount.find(params[:id])
  end

  # POST /user_to_sip_accounts
  # POST /user_to_sip_accounts.xml
  def create
    @user_to_sip_account = UserToSipAccount.new(params[:user_to_sip_account])

    respond_to do |format|
      if @user_to_sip_account.save
        format.html { redirect_to(@user_to_sip_account, :notice => 'User to sip account was successfully created.') }
        format.xml  { render :xml => @user_to_sip_account, :status => :created, :location => @user_to_sip_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_to_sip_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_to_sip_accounts/1
  # PUT /user_to_sip_accounts/1.xml
  def update
    @user_to_sip_account = UserToSipAccount.find(params[:id])

    respond_to do |format|
      if @user_to_sip_account.update_attributes(params[:user_to_sip_account])
        format.html { redirect_to(@user_to_sip_account, :notice => 'User to sip account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_to_sip_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_to_sip_accounts/1
  # DELETE /user_to_sip_accounts/1.xml
  def destroy
    @user_to_sip_account = UserToSipAccount.find(params[:id])
    @user_to_sip_account.destroy

    respond_to do |format|
      format.html { redirect_to(user_to_sip_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
