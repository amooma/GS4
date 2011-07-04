class HomeController < ApplicationController
  
	before_filter :authenticate_user!
  
	load_and_authorize_resource
  
	def index
		if (current_user.role == 'admin')
			@number_of_users         = User.count
			@number_of_sip_accounts  = SipAccount.count
			@number_of_phones        = Phone.count
			@number_of_sip_proxies   = SipProxy.count
			@number_of_sip_servers   = SipServer.count
			@number_of_extensions    = Extension.count
			respond_to do |format|
				format.html { render "admin/index" }
			end
		else
			@sip_accounts = current_user.sip_accounts.all
			@extensions    = SipAccountToExtension.where(:sip_account_id => @sip_accounts)
			respond_to do |format|
				format.html
			end
		end
	end
end
