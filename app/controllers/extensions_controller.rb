class ExtensionsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  before_filter :find_sip_account
  before_filter :find_conference
  before_filter :find_call_queue
  #OPTIMIZE Where is this used?
  
  before_filter {
    @sip_accounts = SipAccount.order([ :auth_name, :sip_server_id ])
    @conferences = Conference.order([ :uuid ])
    @call_queues = CallQueue.order([ :uuid ])
  }
  
  
  # GET /extensions
  # GET /extensions.xml
  def index
    if @sip_account.nil?
      @extensions = Extension.accessible_by( current_ability, :index ).all
    else
      @extensions = @sip_account.extensions.accessible_by( current_ability, :index )
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @extensions }
    end
  end
  
  # GET /extensions/1
  # GET /extensions/1.xml
  def show
    if @sip_account.nil?
      @extension = Extension.find(params[:id])
    else
      @extension = @sip_account.extensions.find(params[:id])
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @extension }
    end
  end
  
  # GET /extensions/new
  # GET /extensions/new.xml
  def new
    if ! @sip_account.nil?
      @extension = @sip_account.extensions.build({
      :active      => true,
      :destination => params[:destination],
      })
    elsif ! @conference.nil?
      @extension = @conference.extensions.build({
      :active      => true,
      :destination => params[:destination],
      })
    elsif ! @call_queue.nil?
      @extension = @call_queue.extensions.build({
      :active      => true,
      :destination => params[:destination],
      })
    else
      @extension = Extension.new
      @extension.active = true
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @extension }
    end
  end
  
  # GET /extensions/1/edit
  def edit
    if @sip_account.nil?
      @extension = Extension.find(params[:id])
    else
      @extension = @sip_account.extensions.find(params[:id])
    end
  end
  
  # POST /extensions
  # POST /extensions.xml
  def create
    redirect_source = true
    extension_type = params[:extension][:type]    
    destination = params[:extension][:destination]

    if ( @sip_account.nil? &&  @conference.nil? &&  @call_queue.nil? )
      redirect_source = false      
      case extension_type
      when 'sipaccount'
        @sip_account    = SipAccount.where(:auth_name => params[:extension][:destination]).first
      when 'conference'    
        @conference  = Conference.where(:uuid => params[:extension][:destination]).first
      when 'queue'
        @call_queue  = CallQueue.where(:uuid => params[:extension][:destination]).first
      when 'faxreceive'
        @user = User.where(:username => params[:extension][:destination]).first
        params[:extension][:destination] = '-fax-receive-'
      when 'vmenu'
        params[:extension][:destination] = '-vmenu-'
      when 'parkin'
        params[:extension][:destination] = '-park-in-'
      when 'parkout'
        params[:extension][:destination] = '-park-out-'
      end
    end

    if ! @sip_account.nil?
      @extension = @sip_account.extensions.build(params[:extension])
      @extension.type = extension_type

      respond_to do |format|
        if @sip_account.save
          format.html { redirect_source ? redirect_to( @sip_account, :notice => t(:extension_created) ) : redirect_to( @extension, :notice => t(:extension_created) )}
          format.xml  { render :xml => @sip_account, :status => :created, :location => @extension }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
        end
      end
    elsif ! @conference.nil?
      @extension = @conference.extensions.build(params[:extension])
      @extension.type = extension_type
  
      respond_to do |format|
        if @conference.save
          format.html { redirect_source ? redirect_to( @conference, :notice => t(:extension_created) ) : redirect_to( @extension, :notice => t(:extension_created) )}
          format.xml  { render :xml => @conference, :status => :created, :location => @extension }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
        end
      end
    elsif ! @call_queue.nil?
      @extension = @call_queue.extensions.build(params[:extension])
      @extension.type = extension_type
  
      respond_to do |format|
        if @call_queue.save
          format.html { redirect_source ? redirect_to( @call_queue, :notice => t(:extension_created) ) : redirect_to( @extension, :notice => t(:extension_created) )}
          format.xml  { render :xml => @call_queue, :status => :created, :location => @extension }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
        end
      end
    elsif ! @user.nil?
      @extension = Extension.new(params[:extension])
      @extension.type = extension_type
  
      if (saved = @extension.save)
        @extension.users << @user
        saved = @extension.save
      end
      @extension.destination = destination
      respond_to do |format|
        if saved
          format.html { redirect_source ? redirect_to( @user, :notice => t(:extension_created) ) : redirect_to( @extension, :notice => t(:extension_created) )}
          format.xml  { render :xml => @user, :status => :created, :location => @extension }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
        end
      end
    elsif extension_type == 'vmenu' || extension_type == 'parkin' ||  extension_type == 'parkout'
      @extension = Extension.new(params[:extension])
      @extension.type = extension_type

      respond_to do |format|
        if @extension.save
          format.html { redirect_to( @extension, :notice => t(:extension_created) )}
          format.xml  { render :xml => @extension, :status => :created, :location => @extension }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
        end
      end
    else
      @extension.type = extension_type
      @extension.errors.add( :base, t('activerecord.attributes.extension.destination'))
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /extensions/1
  # PUT /extensions/1.xml
  def update
    @extension = Extension.find(params[:id])
    
    respond_to do |format|
      if @extension.update_attributes( params[:extension] )
        format.html { redirect_to( @extension, :notice => t(:extension_updated) )}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @extension.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /extensions/1
  # DELETE /extensions/1.xml
  def destroy
    @extension = Extension.find( params[:id] )
    @extension.destroy
    
    respond_to do |format|
      format.html { redirect_to(extensions_url) }
      format.xml  { head :ok }
    end
  end
  
  def confirm_destroy
    @extension = Extension.find( params[:id] )
  end
  
  private
  
  def find_sip_account
    if ! params[:sip_account_id].nil?
      @sip_account = SipAccount.find( params[:sip_account_id] )
    end
  end
  
  def find_conference
    if ! params[:conference_id].nil?
      @conference = Conference.find( params[:conference_id] )
    end
  end
  
  def find_call_queue
    if ! params[:call_queue_id].nil?
      @call_queue = CallQueue.find( params[:call_queue_id] )
    end
  end
  
end
