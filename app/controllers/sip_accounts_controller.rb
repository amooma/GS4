class SipAccountsController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter { |controller|
    @sip_phones   = SipPhone  .order([ :node_id, :phone_id ])
    @sip_servers  = SipServer .order([ :host ])
    @sip_proxies  = SipProxy  .order([ :host ])
    @voicemail_servers = VoicemailServer .order([ :host ])
    @users        = User      .order([ :sn, :gn, :username ])
    
    @num_users       = User      .count
    @num_sip_phones  = SipPhone  .count
  }
  
  # GET /sip_accounts
  # GET /sip_accounts.xml
  def index
    @sip_accounts = SipAccount.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sip_accounts }
    end
  end
  
  # GET /sip_accounts/1
  # GET /sip_accounts/1.xml
  def show
    @sip_account = SipAccount.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sip_account }
    end
  end
  
  # GET /sip_accounts/new
  # GET /sip_accounts/new.xml
  def new
    @sip_account = SipAccount.new
    @sip_account.phone_id = params[:phone_id]
    @sip_account.user_id = params[:user_id]
    @sip_account.sip_server_id = params[:sip_server_id]
    @sip_account.sip_proxy_id = params[:sip_proxy_id]
    @sip_account.voicemail_server_id = params[:voicemail_server_id]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sip_account }
    end
  end
  
  # GET /sip_accounts/1/edit
  def edit
    @sip_account = SipAccount.find(params[:id])
  end
  
  # POST /sip_accounts
  # POST /sip_accounts.xml
  def create
    @sip_account = SipAccount.new(params[:sip_account])
    
    respond_to do |format|
      if @sip_account.save
        format.html { redirect_to(@sip_account, :notice => 'Sip account was successfully created.') }
        format.xml  { render :xml => @sip_account, :status => :created, :location => @sip_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sip_account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /sip_accounts/1
  # PUT /sip_accounts/1.xml
  def update
    @sip_account = SipAccount.find(params[:id])
    
    respond_to do |format|
      if @sip_account.update_attributes(params[:sip_account])
        format.html { redirect_to(@sip_account, :notice => 'Sip account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sip_account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /sip_accounts/1
  # DELETE /sip_accounts/1.xml
  def destroy
    @sip_account = SipAccount.find(params[:id])
    @sip_account.destroy
    
    respond_to do |format|
      format.html { redirect_to(sip_accounts_url) }
      format.xml  { head :ok }
    end
  end
  
end
