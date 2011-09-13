class AdminController < ApplicationController
	
	# Make sure that we have a database.
	rescue_from ActiveRecord::StatementInvalid, :with => :rescue_missing
	
	
	before_filter :authenticate_user!
	
	# https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
	load_and_authorize_resource
	
	
	def index
		@number_of_users           = User          .count
		@number_of_sip_accounts    = SipAccount    .count
		@number_of_phones          = Phone         .count
		@number_of_sip_proxies     = SipProxy      .count
		@number_of_sip_servers     = SipServer     .count
		@number_of_extensions      = Extension     .count
		@number_of_configurations  = Configuration .count
		respond_to do |format|
			format.html
		end
	end
	
	def confirm_shutdown
		respond_to do |format|
			format.html
		end
	end
	
	def shutdown
		if ::Rails.env.to_s == "production"
			# shutdown
			@result = `sudo /sbin/shutdown -h now`  #OPTIMIZE Use -n flag (non-interactive) to sudo.
		end
		
		respond_to do |format|
			format.html
		end
	end
	
	def confirm_reboot
		respond_to do |format|
			format.html
		end
	end
	
	def reboot
		if ::Rails.env.to_s == "production"
			# reboot
			@result = `sudo /sbin/shutdown -r now`  #OPTIMIZE Use -n flag (non-interactive) to sudo.
		end
		
		respond_to do |format|
			format.html
		end
	end
	
	def help
		respond_to do |format|
			format.html
		end
	end
	
	private
	
	def rescue_missing
		redirect_to( '/db_migrate_missing.html' )
	end
	
end
