class PinChangeController < ApplicationController
	 
	before_filter :authenticate_user!

	load_and_authorize_resource

	def edit
		@sip_accounts = current_user.sip_accounts.find(:all, :conditions => ['voicemail_server_id NOT NULL'])
		respond_to do |format|
			format.html
			format.xml { head :ok }
		end
	end
	
	def update
		@sip_accounts = current_user.sip_accounts.find(:all, :conditions => ['voicemail_server_id NOT NULL'])
		@sip_account = current_user.sip_accounts.where(:id => params[:sip_account_id]).first
		if (@sip_account)
			@changes = false
			pin = params[:voicemail_pin]
			old_pin = params[:old_voicemail_pin]
			pin_confirmation = params[:voicemail_pin_confirmation]
			active_pin = @sip_account.voicemail_pin
			if (pin.blank?)
				@sip_account.errors.add( :base, t(:voicemail_no_pin))
				@errors = true
			end
			if (old_pin.blank?)
				@sip_account.errors.add( :base, t(:voicemail_no_old_pin))
				@errors = true
			end
			if (pin_confirmation.blank?)
				@sip_account.errors.add( :base, t(:voicemail_no_pin_confirmation))
				@errors = true
			end
			if (pin_confirmation != pin)
				@sip_account.errors.add( :base, t(:voicemail_pin_confirmation_different))
				@errors = true
			end
			
			if (@errors != true && old_pin.to_i != active_pin)
				@sip_account.errors.add( :base, t(:voicemail_old_pin_different))
				@errors = true
			end
			
			if (@errors != true)
				@errors = ! @sip_account.update_attributes(:voicemail_pin => pin)
				if (! @errors) 
					flash[:notice] = t(:voicemail_pin_changed)
				end
			end
		end
		
		respond_to do |format|
			format.html { render :action => "edit" }
			format.xml { head :ok }
		end
	end
end
