class HomeController < ApplicationController
  
	before_filter :authenticate_user!
  
	load_and_authorize_resource
  
	def index
		if (current_user.role == 'admin1')
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
			@sip_accounts    = current_user.sip_accounts.all
			@extensions      = SipAccountToExtension.where(:sip_account_id => @sip_accounts).all
			@call_forwards   = CallForward.accessible_by( current_ability, :index ).where(:sip_account_id => @sip_accounts, :active => true).all
			@call_log_missed    = CallLog.accessible_by( current_ability, :index ).where(:sip_account_id => @sip_accounts, :disposition => DISPOSITION_NOANSWER, :call_type => CALL_INBOUND ).all
			
			respond_to do |format|
				format.html
			end
		end
	end
	
	private
	DISPOSITION_NOANSWER = 'noanswer'
	DISPOSITION_ANSWERED = 'answered'
	DISPOSITION_FORWARDED = 'forwarded'
	CALL_INBOUND = 'in'
	CALL_OUTBOUND = 'out'
end
