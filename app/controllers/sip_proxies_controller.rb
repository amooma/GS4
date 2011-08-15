class SipProxiesController < ApplicationController
  
  skip_before_filter :setup, :only => [ :new, :create ]
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  before_filter { |controller|
    @sip_proxies = SipProxy.accessible_by( current_ability, :index ).all
  }
  
  # GET /sip_proxies
  # GET /sip_proxies.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sip_proxies }
    end
  end
  
  # GET /sip_proxies/1
  # GET /sip_proxies/1.xml
  def show
    @sip_proxy = SipProxy.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sip_proxy }
    end
  end
  
  # GET /sip_proxies/new
  # GET /sip_proxies/new.xml
  def new
    @sip_proxy = SipProxy.new
    if SipProxy.count == 0
      @sip_proxy.host = guess_local_host
      @sip_proxy.is_local = true
      @sip_proxy.port = 5060  #OPTIMIZE Remove (see Message-ID: <4E2CBA1A.8090404@amooma.de>, https://groups.google.com/group/amooma-dev/msg/99ab848d9c7659ce) and test.
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sip_proxy }
    end
  end
    
  # POST /sip_proxies
  # POST /sip_proxies.xml
  def create
    @sip_proxy = SipProxy.new(params[:sip_proxy])
    
    respond_to do |format|
      if @sip_proxy.save
        format.html { redirect_to(@sip_proxy, :notice => t(:sip_proxy_created)) }
        format.xml  { render :xml => @sip_proxy, :status => :created, :location => @sip_proxy }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sip_proxy.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # DELETE /sip_proxies/1
  # DELETE /sip_proxies/1.xml
  def destroy
    @sip_proxy = SipProxy.find(params[:id])
    @sip_proxy.destroy
    
    respond_to do |format|
      format.html { redirect_to(sip_proxies_url) }
      format.xml  { head :ok }
    end
  end
  
end
