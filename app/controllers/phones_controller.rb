class PhonesController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  # GET /phones
  # GET /phones.xml
  def index
    if params[:mac_address]
      @phones = Phone.accessible_by( current_ability, :index ).where('mac_address'=> params[:mac_address])
    elsif params[:ip_address]
      @phones = Phone.accessible_by( current_ability, :index ).where('ip_address' => params[:ip_address])
    elsif ! params[:phone_model_id].blank?
      @phones = PhoneModel.find(params[:phone_model_id]).phones.accessible_by( current_ability, :index )
    else
      @phones = Phone.accessible_by( current_ability, :index ).all      
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @phones }
    end
  end
  
  # GET /phones/1
  # GET /phones/1.xml
  def show
    @phone = Phone.find(params[:id])
    
    @sip_accounts = @phone.sip_accounts.accessible_by( current_ability, :index )
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone }
    end
  end
  
  # GET /phones/new
  # GET /phones/new.xml
  def new
    @phone = Phone.new
    @phone_models = PhoneModel.accessible_by( current_ability, :index ).order(:name)
    
    if !params[:phone_model_id].nil? and PhoneModel.exists?(params[:phone_model_id])
      @phone.phone_model_id = params[:phone_model_id]
    else
      @phone.phone_model_id = Phone.last ? Phone.last.phone_model.id : nil
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @phone }
    end
  end
  
  # GET /phones/1/edit
  def edit
    @phone = Phone.find(params[:id])
    
    @phone_models = PhoneModel.accessible_by( current_ability, :index ).order(:name)
  end
  
  # POST /phones
  # POST /phones.xml
  def create
    @phone = Phone.new(params[:phone])
    @phone_models = PhoneModel.accessible_by( current_ability, :index ).order(:name)
    
    respond_to do |format|
      if @phone.save
        format.html { redirect_to( @phone, :notice => t(:phone_created)) }
        format.xml  { render :xml => @phone, :status => :created, :location => @phone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /phones/1
  # PUT /phones/1.xml
  def update
    @phone = Phone.find(params[:id])
    @phone_models = PhoneModel.accessible_by( current_ability, :index ).order(:name)
    
    if @phone.update_attributes(params[:http_password]) \
    || @phone.update_attributes(params[:http_user])
      @phone.reboot
    end
    
    respond_to do |format|
      if @phone.update_attributes(params[:phone])
        format.html { redirect_to( @phone, :notice => t(:phone_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /phones/1
  # DELETE /phones/1.xml
  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy
    
    respond_to do |format|
      format.html { redirect_to( phones_url ) }
      format.xml  { head :ok }
    end
  end
  
  def confirm_destroy
    @phone = Phone.find(params[:id])
  end
  
  # Reboots the phone
  def reboot
    @phone = Phone.find(params[:id])
    @phone.reboot
    redirect_to( @phone, :notice => t(:phone_rebooting))
  end
  
end
