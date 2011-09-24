class Admin::MailConfigurationController < ApplicationController
	
	before_filter :authenticate_user!
	
	skip_authorization_check
	
	before_filter {
		@email_configuration = EmailConfiguration.new()
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
		@email_configuration = EmailConfiguration.new( params[:email_configuration] )
		
		respond_to do |format|
			if @email_configuration.save
				format.html { redirect_to( :action => 'show' ) }
			else
				format.html { render :action => "edit" }
			end
		end
	end
	
end
