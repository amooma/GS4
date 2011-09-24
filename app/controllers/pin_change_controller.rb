class PinChangeController < ApplicationController
	
	before_filter :authenticate_user!
	
	# https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
	load_and_authorize_resource
	
	
	def edit
		@sip_accounts = current_user.sip_accounts.find(:all, :conditions => ['voicemail_server_id NOT NULL'])
		if @sip_account  = @sip_accounts.first
			@sip_account.voicemail_pin = nil
		else
			@sip_account = SipAccount.new
		end
		
		respond_to do |format|
			format.html
		end
	end
	
	def update
		@sip_accounts = current_user.sip_accounts.find(:all, :conditions => ['voicemail_server_id NOT NULL'])
		@sip_account  = current_user.sip_accounts.where(:id => params[:sip_account][:id]).first
		
		if @sip_account
			pin              = params[:sip_account][:voicemail_pin]
			old_pin          = params[:sip_account][:voicemail_pin_old]
			pin_confirmation = params[:sip_account][:voicemail_pin_confirmation]
			current_pin      = @sip_account.voicemail_pin
			@sip_account.voicemail_pin = nil
			
			if (pin.blank?)
				@sip_account.errors.add( :voicemail_pin, t(:voicemail_no_pin))
			end
			if (old_pin.blank?)
				@sip_account.errors.add( :voicemail_pin_old, t(:voicemail_no_old_pin))
			end
			if (pin_confirmation.blank?)
				@sip_account.errors.add( :voicemail_pin_confirmation, t(:voicemail_no_pin_confirmation))
			end
			if (pin_confirmation != pin)
				@sip_account.errors.add( :voicemail_pin_confirmation, t(:voicemail_pin_confirmation_different))
			end
			if (old_pin.to_i != current_pin)
				@sip_account.errors.add( :voicemail_pin_old, t(:voicemail_old_pin_different))
			end
			
			if (@sip_account.errors.blank? && @sip_account.update_attributes(:voicemail_pin => pin))
				flash[:notice] = t(:voicemail_pin_changed)
			end
		end
		
		respond_to do |format|
			format.html { render :action => "edit" }
			format.xml  { head :ok }
		end
	end
	
end
