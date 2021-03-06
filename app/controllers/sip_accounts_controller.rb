class SipAccountsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  before_filter { |controller|
    @sip_servers  = SipServer .accessible_by( current_ability, :index ).order([ :host ])
    @sip_proxies  = SipProxy  .accessible_by( current_ability, :index ).order([ :host ])
    @voicemail_servers = VoicemailServer .accessible_by( current_ability, :index ).order([ :host ])
    @users        = User      .accessible_by( current_ability, :index ).order([ :sn, :gn, :username ]).keep_if{ |u| Ability.new(u).can?(:have, SipAccount) }
    @num_users    = User      .accessible_by( current_ability, :index ).count
  }
  
  # GET /sip_accounts
  # GET /sip_accounts.xml
  def index
    @sip_accounts = SipAccount.accessible_by( current_ability, :index ).all
    
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
    @sip_account                      = SipAccount.new
    @sip_account.phone_id             = params[:phone_id]
    @sip_account.user_id              = params[:user_id]
    @sip_account.sip_server_id        = params[:sip_server_id]
    @sip_account.sip_proxy_id         = params[:sip_proxy_id]
    @sip_account.voicemail_server_id  = params[:voicemail_server_id]
    @sip_account.auth_name            = SecureRandom.hex(10)
    @sip_account.password             = SecureRandom.hex(15)
    
    if SipServer.count == 1
      @sip_account.sip_server = SipServer.accessible_by( current_ability, :index ).first
    end
    if SipProxy.count == 1
      @sip_account.sip_proxy  = SipProxy.accessible_by( current_ability, :index ).first
      @sip_account.realm      = SipProxy.accessible_by( current_ability, :index ).first.try(:host)
    end
    if VoicemailServer.count == 1
      @sip_account.voicemail_server = VoicemailServer.accessible_by( current_ability, :index ).first
    end
    
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
        format.html { redirect_to(@sip_account, :notice => t(:sip_account_created)) }
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
        format.html { redirect_to(@sip_account, :notice => t(:sip_account_updated)) }
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
  
  def confirm_destroy
    @sip_account = SipAccount.find(params[:id])
  end
  
end
