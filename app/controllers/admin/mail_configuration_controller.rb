class Admin::MailConfigurationController < ApplicationController
	
	before_filter :authenticate_user!
	
	skip_authorization_check
	
	before_filter {
		@smarthost_hostname              = Configuration.get( :smarthost_hostname, '127.0.0.1' )
		@smarthost_port                  = Configuration.get( :smarthost_port, 25, Integer )
		@smarthost_domain                = Configuration.get( :smarthost_domain, 'gemeinschaft.local' )
		@smarthost_username              = Configuration.get( :smarthost_username, '' )
		@smarthost_password              = Configuration.get( :smarthost_password, '' )
		@smarthost_authentication        = Configuration.get( :smarthost_authentication, 'plain' )
		@smarthost_enable_starttls_auto  = Configuration.get( :smarthost_enable_starttls_auto, true, Configuration::Boolean )
		
		@mailserver_hostname = Configuration.get(:mailserver_hostname)
		@mailserver_port     = Configuration.get(:mailserver_port, 110, Integer)
		@mailserver_username = Configuration.get(:mailserver_username)
		@mailserver_password = Configuration.get(:mailserver_password)
		
		@fax_send_mail = Configuration.get(:fax_send_mail, true, Configuration::Boolean)
		@fax_pop3      = Configuration.get(:fax_pop3, false, Configuration::Boolean)	
	}
	
	def edit
		respond_to do |format|
			format.html
		end
	end
	
	def show
		respond_to do |format|
			format.html
		end
	end
	
	def index
		respond_to do |format|
			format.html { render :action => "edit" }
		end
	end
	
	def create
		if  params[:email_configuration]
			params[:email_configuration].each_pair do |name,value|
				if ( configuration = Configuration.where( :name => name ).first )
					configuration.update_attributes( :value => value )
				else
					Configuration.create( :name => name, :value => value )
				end
			end
		end
		
		respond_to do |format|
			format.html { redirect_to( :action => 'show' ) }
		end
	end
	
end
