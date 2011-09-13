class Admin::WizardPhoneAndUserController < ApplicationController
	
	before_filter :authenticate_user!
	
	skip_authorization_check
	
	before_filter {
		@sip_proxy         = SipProxy.where(:is_local => true).first
		@sip_server        = SipServer.where(:is_local => true).first
		@voicemail_server  = VoicemailServer.where(:is_local => true).first
		@phone_models      = PhoneModel.all
	}
	
	def new
		@phone = Phone.new
		my_extension = Extension.next_unused_extension
		sip_account = @phone.sip_accounts.build(
			:auth_name => SecureRandom.hex(10),
			:password => SecureRandom.hex(15),
			:realm => @sip_server.host,
			:sip_server_id => @sip_server.id,
			:sip_proxy_id => @sip_proxy.id,
			:voicemail_server_id => @voicemail_server.id,
			:voicemail_pin => 100000 + SecureRandom.random_number( 899999 ),
			:caller_name => "#{I18n.t(:default_caller_name)} #{my_extension}"
		)
		extension = sip_account.extensions.build(
			:extension => my_extension,
			:destination => sip_account.auth_name,
			:active => true
		)
		
		respond_to do |format|
			format.html 
		end
	end
	
	def create
		@phone = Phone.new(params[:phone])
		
		respond_to do |format|
			if @phone.save
				format.html { redirect_to( root_path, :notice => I18n.t(:wizard_phone_and_user_saved) ) }
			else
				format.html { render :action => "new" }
			end
		end
	end
	
end
