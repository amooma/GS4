class HomeController < ApplicationController
	
	# The first time you have to setup an admin account.
	before_filter :check_if_admin_account_exists
	
	
	before_filter :authenticate_user!
	
	# https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
	load_and_authorize_resource
	def help
	end
	
	def index
		case current_user.role
		when 'admin'
			@number_of_users         = User.count
			@number_of_sip_accounts  = SipAccount.count
			@number_of_phones        = Phone.count
			@number_of_sip_proxies   = SipProxy.count
			@number_of_sip_servers   = SipServer.count
			@number_of_extensions    = Extension.count
			
			@phones = Phone.order('updated_at desc').limit(5)
			
			respond_to do |format|
				format.html { render "admin/index" }
			end
		when 'user'
			@sip_accounts    = current_user.sip_accounts.all
			@extensions      = SipAccountToExtension.where(:sip_account_id => @sip_accounts).all
			@call_forwards   = CallForward.accessible_by( current_ability, :index ).where(:sip_account_id => @sip_accounts, :active => true).all
			@call_log_missed = CallLog.accessible_by( current_ability, :index ).where(:sip_account_id => @sip_accounts, :disposition => DISPOSITION_NOANSWER, :call_type => CALL_INBOUND ).all
			
			respond_to do |format|
				format.html
			end
		when 'cdr'
			redirect_to( cdrs_path )
			#render :status => '200 OK',
			#	:layout => true, :content_type => 'text/html',
			#	:text => "You have permission to list the call records."
		else
			flash[:alert] = "Unknown role."
			render :status => '500 Server error',
				:layout => true, :content_type => 'text/html',
				:text => "Server error."
		end
	end
	
	private
	
	def check_if_admin_account_exists
		if User.count == 0
			redirect_to( new_admin_setup_path )
		end
	end
	
	DISPOSITION_NOANSWER  = 'noanswer'
	DISPOSITION_ANSWERED  = 'answered'
	DISPOSITION_FORWARDED = 'forwarded'
	
	CALL_INBOUND  = 'in'
	CALL_OUTBOUND = 'out'
	
end
