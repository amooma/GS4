class ExtensionsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter { @sip_accounts = SipAccount.all}  
  # GET /extensions
  # GET /extensions.xml
  def index
    @extensions = Extension.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @extensions }
    end
  end

  # GET /extensions/1
  # GET /extensions/1.xml
  def show
    @extension = Extension.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @extension }
    end
  end

  # GET /extensions/new
  # GET /extensions/new.xml
  def new
    @extension = Extension.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @extension }
    end
  end

  # GET /extensions/1/edit
  def edit
    @extension = Extension.find(params[:id])
  end

  # POST /extensions
  # POST /extensions.xml
  def create
    @extension = Extension.new(params[:extension])

    respond_to do |format|
      if @extension.save
        format.html { redirect_to(@extension, :notice => 'Extension was successfully created.') }
        format.xml  { render :xml => @extension, :status => :created, :location => @extension }
      else
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
      if @extension.update_attributes(params[:extension])
        format.html { redirect_to(@extension, :notice => 'Extension was successfully updated.') }
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
    @extension = Extension.find(params[:id])
    @extension.destroy

    respond_to do |format|
      format.html { redirect_to(extensions_url) }
      format.xml  { head :ok }
    end
  end
  
end
