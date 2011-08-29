class VoicemailServersController < ApplicationController
  
  skip_before_filter :setup, :only => [ :new, :create ]
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  # GET /voicemail_servers
  # GET /voicemail_servers.xml
  def index
    @voicemail_servers = VoicemailServer.accessible_by( current_ability, :index ).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @voicemail_servers }
    end
  end

  # GET /voicemail_servers/1
  # GET /voicemail_servers/1.xml
  def show
    @voicemail_server = VoicemailServer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @voicemail_server }
    end
  end

  # GET /voicemail_servers/new
  # GET /voicemail_servers/new.xml
  def new
    @voicemail_server = VoicemailServer.new
    
    if VoicemailServer.count == 0
      @voicemail_server.host = guess_local_host
      @voicemail_server.is_local = true
      @voicemail_server.port = 5060  #OPTIMIZE Remove (see Message-ID: <4E2CBA1A.8090404@amooma.de>, https://groups.google.com/group/amooma-dev/msg/99ab848d9c7659ce) and test.
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @voicemail_server }
    end
  end

  # GET /voicemail_servers/1/edit
  def edit
    @voicemail_server = VoicemailServer.find(params[:id])
  end

  # POST /voicemail_servers
  # POST /voicemail_servers.xml
  def create
    @voicemail_server = VoicemailServer.new(params[:voicemail_server])

    respond_to do |format|
      if @voicemail_server.save
        format.html { redirect_to(@voicemail_server, :notice => t(:voicemail_server_created)) }
        format.xml  { render :xml => @voicemail_server, :status => :created, :location => @voicemail_server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @voicemail_server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /voicemail_servers/1
  # PUT /voicemail_servers/1.xml
  def update
    @voicemail_server = VoicemailServer.find(params[:id])

    respond_to do |format|
      if @voicemail_server.update_attributes(params[:voicemail_server])
        format.html { redirect_to(@voicemail_server, :notice => t(:voicemail_server_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @voicemail_server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /voicemail_servers/1
  # DELETE /voicemail_servers/1.xml
  def destroy
    @voicemail_server = VoicemailServer.find(params[:id])
    @voicemail_server.destroy

    respond_to do |format|
      format.html { redirect_to(voicemail_servers_url) }
      format.xml  { head :ok }
    end
  end
  
  def confirm_destroy
    @voicemail_server = VoicemailServer.find(params[:id])
  end  
  
end
