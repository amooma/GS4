class NetworkSettingsController < ApplicationController

  skip_before_filter :setup, :only => [:new, :create]
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  # GET /network_settings
  # GET /network_settings.xml
  def index
    @network_settings = NetworkSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @network_settings }
    end
  end

  # GET /network_settings/1
  # GET /network_settings/1.xml
  def show
    @network_setting = NetworkSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @network_setting }
    end
  end

  # GET /network_settings/new
  # GET /network_settings/new.xml
  def new
    @network_setting = NetworkSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network_setting }
    end
  end

  # GET /network_settings/1/edit
  def edit
    @network_setting = NetworkSetting.find(params[:id])
  end

  # POST /network_settings
  # POST /network_settings.xml
  def create
    @network_setting = NetworkSetting.new(params[:network_setting])

    respond_to do |format|
      if @network_setting.save
        format.html { redirect_to(@network_setting, :notice => t.(:network_setting_created)) }
        format.xml  { render :xml => @network_setting, :status => :created, :location => @network_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @network_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /network_settings/1
  # PUT /network_settings/1.xml
  def update
    @network_setting = NetworkSetting.find(params[:id])

    respond_to do |format|
      if @network_setting.update_attributes(params[:network_setting])
        format.html { redirect_to(@network_setting, :notice => t(:network_setting_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /network_settings/1
  # DELETE /network_settings/1.xml
  def destroy
    @network_setting = NetworkSetting.find(params[:id])
    @network_setting.destroy

    respond_to do |format|
      format.html { redirect_to(network_settings_url) }
      format.xml  { head :ok }
    end
  end
end
