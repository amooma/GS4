class SipPhonesController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter { |controller|
    @sip_phones   = SipPhone.order([ :node_id, :phone_id ])
    @nodes = Node.order([ :title ])
    
    @num_nodes = Node.count
  }
  
  # GET /sip_phones
  # GET /sip_phones.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sip_phones }
    end
  end
  
  # GET /sip_phones/1
  # GET /sip_phones/1.xml
  def show
    @sip_phone = SipPhone.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sip_phone }
    end
  end
  
  # GET /sip_phones/new
  # GET /sip_phones/new.xml
  def new
    @sip_phone = SipPhone.new
    if Node.count == 1
      @sip_phone.node = Node.first
      setup_cantina_phone
    end
    
    respond_to do |format|
      if Node.count == 0
        format.html { redirect_to(new_node_path, :alert => 'To create a new SIP phone you have to create a node first.') }
        format.xml  { render :xml => @sip_phone }
      else
        format.html # new.html.erb
        format.xml  { render :xml => @sip_phone }
      end
    end
  end
  
  # GET /sip_phones/1/edit
  def edit
    @sip_phone = SipPhone.find(params[:id])
    setup_cantina_phone
  end
  
  # POST /sip_phones
  # POST /sip_phones.xml
  def create
    @sip_phone = SipPhone.new(params[:sip_phone])
    setup_cantina_phone
    
    respond_to do |format|
      if @sip_phone.save
        format.html { redirect_to(@sip_phone, :notice => 'Sip phone was successfully created.') }
        format.xml  { render :xml => @sip_phone, :status => :created, :location => @sip_phone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sip_phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /sip_phones/1
  # PUT /sip_phones/1.xml
  def update
    @sip_phone = SipPhone.find(params[:id])
    setup_cantina_phone
    respond_to do |format|
      if @sip_phone.update_attributes(params[:sip_phone])
        format.html { redirect_to(@sip_phone, :notice => 'Sip phone was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sip_phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /sip_phones/1
  # DELETE /sip_phones/1.xml
  def destroy
    @sip_phone = SipPhone.find(params[:id])
    @sip_phone.destroy
    
    respond_to do |format|
      format.html { redirect_to(sip_phones_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def setup_cantina_phone
    if @sip_phone.node_id != nil
      host = Node.find( @sip_phone.node_id ).management_host
      port = Node.find( @sip_phone.node_id ).management_port
      CantinaPhone.set_resource( "http://#{host}:#{port}" )
      #FIXME Remove CantinaPhone.
    end
  end  
  
end
