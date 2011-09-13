class Admin::WizardPhoneAndUserController < ApplicationController
before_filter :authenticate_user!

skip_authorization_check

before_filter{
    @sip_proxy = SipProxy.where(:is_local => true).first
    @sip_server = SipServer.where(:is_local => true).first
    @voicemail_server = VoicemailServer.where(:is_local => true).first
    
    @phone_models = PhoneModel.all

}
  def new
     respond_to do |format|
      format.html 
    end
  end

  def create

    @auth_name = SecureRandom.hex(10)
    @sip_password = SecureRandom.hex(15)
    @user = User.find_or_create_by_username_and_role(
      :username => params[:wusername],
      :first_name => params[:wfirst_name],
      :last_name => params[:wlast_name],
      :password => params[:wpassword],
      :password_confirmation => params[:wpassword_confirmation],
      :email => params[:wemail],
      :role => 'user'
    )
    if @user.save
    @phone = Phone.find_or_create_by_mac_address(
      :mac_address => params[:wmac_address].upcase,
      :phone_model_id => params[:phone_model_id]
    )
    
   
    @sip_account = SipAccount.find_or_create_by_caller_name_and_user_id(
      :user_id => @user.id,
      :auth_name => @auth_name,
      :password => @sip_password,
      :realm => @sip_server.host,
      :sip_server_id => @sip_server.id,
      :sip_proxy_id => @sip_proxy.id,
      :voicemail_server_id => @voicemail_server.id,
      :voicemail_pin => params[:wvoicemail_pin],
      :caller_name => params[:wcaller_name],
      :phone_id => @phone.id
      
    )
    
   
    @extension = Extension.find_or_create_by_extension_and_destination(
    :extension => params[:wextension],
    :destination =>  @auth_name,
    :active => true
    )
    
   
    @sip_account_to_extension = SipAccountToExtension.find_or_create_by_extension_id_and_sip_account_id(
      :extension_id => @extension.id,
      :sip_account_id => @sip_account.id
    )
   end
   
  
   

    respond_to do |format|
      if  ! @user.id.nil? && ! @phone.id.nil? && ! @sip_account.id.nil? && ! @extension.id.nil?
        format.html { redirect_to( admin_index_path, :notice => I18n.t(:wizard_phone_and_user_saved) ) }
        else
        format.html { render :action => "new" }
      end 
    end
  end
end
