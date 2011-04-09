class ProvisioningServersController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter { |controller|
    @provisioning_servers = ProvisioningServer.all
    @sip_phones = SipPhone.order(:id)
  }
  
  # GET /provisioning_servers
  # GET /provisioning_servers.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @provisioning_servers }
    end
  end
  
  # GET /provisioning_servers/1
  # GET /provisioning_servers/1.xml
  def show
    @provisioning_server = ProvisioningServer.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @provisioning_server }
    end
  end
  
  # GET /provisioning_servers/new
  # GET /provisioning_servers/new.xml
  def new
    @provisioning_server = ProvisioningServer.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @provisioning_server }
    end
  end
  
  # GET /provisioning_servers/1/edit
  def edit
    @provisioning_server = ProvisioningServer.find(params[:id])
  end
  
  # POST /provisioning_servers
  # POST /provisioning_servers.xml
  def create
    @provisioning_server = ProvisioningServer.new(params[:provisioning_server])
    
    respond_to do |format|
      if @provisioning_server.save
        format.html { redirect_to(@provisioning_server, :notice => 'Provisioning server was successfully created.') }
        format.xml  { render :xml => @provisioning_server, :status => :created, :location => @provisioning_server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @provisioning_server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /provisioning_servers/1
  # PUT /provisioning_servers/1.xml
  def update
    @provisioning_server = ProvisioningServer.find(params[:id])
    
    respond_to do |format|
      if @provisioning_server.update_attributes(params[:provisioning_server])
        format.html { redirect_to(@provisioning_server, :notice => 'Provisioning server was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @provisioning_server.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /provisioning_servers/1
  # DELETE /provisioning_servers/1.xml
  def destroy
    @provisioning_server = ProvisioningServer.find(params[:id])
    @provisioning_server.destroy
    
    respond_to do |format|
      format.html { redirect_to(provisioning_servers_url) }
      format.xml  { head :ok }
    end
  end
  
end
