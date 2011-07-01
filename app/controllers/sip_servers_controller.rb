class SipServersController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  before_filter { |controller|
     @sip_servers = SipServer.accessible_by( current_ability, :index ).all
  }
  
  # GET /sip_servers
  # GET /sip_servers.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sip_servers }
    end
  end
  
  # GET /sip_servers/1
  # GET /sip_servers/1.xml
  def show
    @sip_server = SipServer.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sip_server }
    end
  end
  
  # GET /sip_servers/new
  # GET /sip_servers/new.xml
  def new
    @sip_server = SipServer.new
    
    if SipServer.count == 0
      @sip_server.host = request.env['SERVER_NAME']
      @sip_server.is_local= true
      @sip_server.port = "5060"
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sip_server }
    end
  end
  
 
  # POST /sip_servers
  # POST /sip_servers.xml
  def create
    @sip_server = SipServer.new(params[:sip_server])
    
    respond_to do |format|
      if @sip_server.save
        format.html { redirect_to(@sip_server, :notice => t(:sip_server_created)) }
        format.xml  { render :xml => @sip_server, :status => :created, :location => @sip_server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sip_server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /sip_servers/1
  # DELETE /sip_servers/1.xml
  def destroy
    @sip_server = SipServer.find(params[:id])
    @sip_server.destroy
    
    respond_to do |format|
      format.html { redirect_to(sip_servers_url) }
      format.xml  { head :ok }
    end
  end
  
end
