class ManufacturerSnomController < ApplicationController
	
	#TODO Authentication (=> pko) See freeswitch_*_controller.rb
	# No development access for admins though as this contains personal data.
	
	# We can't use load_and_authorize_resource here because
	# ManufacturerSnom isn't a resource.
	skip_authorization_check
	
	#OPTIMIZE Use https for @xml_menu_url
	
	before_filter { |controller|
		@cfwd_case_busy_id      = CallForwardReason.where( :value => "busy"      ).first.try(:id)
		@cfwd_case_noanswer_id  = CallForwardReason.where( :value => "noanswer"  ).first.try(:id)
		@cfwd_case_offline_id   = CallForwardReason.where( :value => "offline"   ).first.try(:id)
		@cfwd_case_always_id    = CallForwardReason.where( :value => "always"    ).first.try(:id)
		@cfwd_case_assistant_id = CallForwardReason.where( :value => "assistant" ).first.try(:id)
		
		if ! params[:mac_address].blank?
			@mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		else
			render(
				:status => 404,
				:layout => false,
				:content_type => 'text/plain',
				:text => "<!-- No phone specified. -->",
			)
		end
		
		@phone = Phone.where(:mac_address => @mac_address).first
		
		if (@phone)
			if (controller.action_name == 'show')
				# Nothing?
			elsif (@phone.ip_address == request.remote_ip)
				@user = get_user_by_phone(@phone)
				@sip_account = get_sip_account(@phone, params[:sip_account])
				
				if (@sip_account)
					@sip_account_id = @sip_account.id
					@sip_account_name = @sip_account.caller_name
					@xml_menu_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{@mac_address}/#{@sip_account_id}"
				else
					@sip_account_id = nil
					@sip_account_name = ''
					@xml_menu_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{@mac_address}"
				end
			else
				render(
					:status => 404,
					:layout => false,
					:content_type => 'text/plain',
					:text => "<!-- IP address #{request.remote_ip} not authorized. -->",
				)
			end
		else
			render(
				:status => 404,
				:layout => false,
				:content_type => 'text/plain',
				:text => "<!-- Phone #{@mac_address.inspect} not found. -->",
			)
		end
	}
	
	def show
		##### Codec mapping {
		# map from Codec names as in seeds.rb to their respective name
		# (or rather: number) on Snom:
		@codec_mapping_snom = {
			'ulaw' =>  0,  # G.711 u-law
			'alaw' =>  8,  # G.711 a-law
			'gsm'  =>  3,  # GSM
			'g722' =>  9,  # G.722
			'g726' =>  2,  # G.726-32  Assume that "g726" in the codecs table means G.726-32.
			'g729' => 18,  # G.729a
			'g723' =>  4,  # G.723.1  Assume that "g723" in the codecs table does not mean G.723 but G.723.1.
		}
		##### Codec mapping }
		
		
		if (! request.env['HTTP_USER_AGENT'].index("snom").nil?)
			call_forwarding_save
			@phone.provisioning_log_entries.create(:succeeded => true, :memo => "Phone got config")
			@phone.update_attributes(:ip_address => request.remote_ip)
		end
		
		respond_to { |format|
			format.xml
		}
	end
	
	def xml_menu
		@sip_accounts_count = @phone.sip_accounts.count
		@global_contacts = GlobalContact.all
		if (@user)
			@personal_contacts = PersonalContact.where(:user_id => @user.id).all
		end
	end
	
	def phone_books_menu
		@global_contacts = GlobalContact.all
		if (@user)
			@personal_contacts = PersonalContact.where(:user_id => @user.id).all
		end
		if (!@global_contacts && !@personal_contacts)
			@sip_accounts = SipAccount.all
			render :action => 'phone_book_internal'
		end
	end
	
	def phone_book_internal
		@sip_accounts = SipAccount.all
	end
	
	def personal_contacts
		if (@user)
			@personal_contacts = PersonalContact.where(:user_id => @user.id).all
		end
	end
	
	def global_contacts
		@global_contacts = GlobalContact.all
	end
	
	def call_log
		if (@sip_account)
			@call_logs_in        = CallLog.where(:sip_account_id => @sip_account.id, :disposition => DISPOSITION_ANSWERED, :call_type => CALL_INBOUND ).all.count
			@call_logs_out       = CallLog.where(:sip_account_id => @sip_account.id, :call_type => CALL_OUTBOUND ).all.count
			@call_logs_missed    = CallLog.where(:sip_account_id => @sip_account.id, :disposition => DISPOSITION_NOANSWER, :call_type => CALL_INBOUND ).all.count
			call_logs_all_in     = CallLog.where(:sip_account_id => @sip_account.id, :call_type => CALL_INBOUND ).all.count #OPTIMIZE user appropriate query  -- Huh?
			@call_logs_forwarded = CallLog.where(:sip_account_id => @sip_account.id, :call_type => CALL_INBOUND,  :disposition => DISPOSITION_FORWARDED ).all.count 
		end
	end
	
	def call_log_in
		if (@sip_account)
			@call_logs_in = CallLog.where(
				:sip_account_id => @sip_account.id,
				:disposition => DISPOSITION_ANSWERED,
				:call_type => CALL_INBOUND 
			).limit(DISPLAY_MAX_ENTRIES).order('created_at DESC')
		end
	end
	
	def call_log_missed
		if (@sip_account)
			@call_logs_missed = CallLog.where(
				:sip_account_id => @sip_account.id,
				:disposition => DISPOSITION_NOANSWER,
				:call_type => CALL_INBOUND
			).limit(DISPLAY_MAX_ENTRIES).order('created_at DESC')
		end
	end
	
	def call_log_out
		if (@sip_account)
			@call_logs_out = CallLog.where(
				:sip_account_id => @sip_account.id, 
				:call_type => CALL_OUTBOUND
			).limit(DISPLAY_MAX_ENTRIES).order('created_at DESC')
		end
	end
	
	def call_log_forwarded
		if (@sip_account)
			@call_logs_forwarded = CallLog.where(
				:sip_account_id => @sip_account.id,
				:call_type => CALL_INBOUND,
				:disposition => DISPOSITION_FORWARDED
				).order('created_at DESC')
		end
		@max_entries = DISPLAY_MAX_ENTRIES
	end
	
	def call_forwarding
		if (@sip_account)
			@always_destination    = get_call_forward( @sip_account, @cfwd_case_always_id )
			@noanswer_destination  = get_call_forward( @sip_account, @cfwd_case_noanswer_id )
			@busy_destination      = get_call_forward( @sip_account, @cfwd_case_busy_id )
			@offline_destination   = get_call_forward( @sip_account, @cfwd_case_offline_id )
			@assistant_destination = get_call_forward( @sip_account, @cfwd_case_assistant_id )
		end
	end
	
	def call_forwarding_always
		@always_destination    = get_call_forward( @sip_account, @cfwd_case_always_id )
	end
	
	def call_forwarding_assistant
		@assistant_destination = get_call_forward( @sip_account, @cfwd_case_assistant_id )
	end
	
	def call_forwarding_busy
		@busy_destination      = get_call_forward( @sip_account, @cfwd_case_busy_id )
	end
	
	def call_forwarding_offline
		@offline_destination   = get_call_forward( @sip_account, @cfwd_case_offline_id )
	end
	
	def call_forwarding_noanswer
		if (@sip_account)
			@query_timeout = params[:query_timeout]
			@cfwd_destination = params[:destination]
			if (@query_timeout && @cfwd_destination.blank?)
				render :action => 'call_forwarding_save'  
			end
			@noanswer_destination  = get_call_forward( @sip_account, @cfwd_case_noanswer_id )
			if (call_forward = @sip_account.call_forwards.where( :call_forward_reason_id => @cfwd_case_noanswer_id, :active => true  , :source => '' ).first \
			||  call_forward = @sip_account.call_forwards.where( :call_forward_reason_id => @cfwd_case_noanswer_id, :active => false , :source => '' ).first
			)
				@noanswer_timeout = call_forward.call_timeout
			else
				@noanswer_timeout = 20
			end
		end
	end
	
	def call_forwarding_save
		reason = nil

		cfwd_case = params[:case]
		cfwd_destination = params[:destination]
		cfwd_timeout = params[:timeout]
		
		case cfwd_case
		when 'busy'
			@title = t(:call_forwarding_busy)
			reason = @cfwd_case_busy_id
		when 'offline'
			@title = t(:call_forwarding_offline)
			reason = @cfwd_case_offline_id
		when 'noanswer'
			@title = t(:call_forwarding_noanswer)
			reason = @cfwd_case_noanswer_id
		when 'assistant'
			@title = t(:call_forwarding_assistant)
			reason = @cfwd_case_assistant_id
		else
			@title = t(:call_forwarding_always)
			reason = @cfwd_case_always_id
		end
		
		call_forward = save_call_forward( @sip_account, reason, cfwd_destination, cfwd_timeout )
		if (call_forward)
			@message = t(:call_forwarding_saved)
		else
			@message = t(:call_forwarding_not_saved)
		end
	end
	
	def call_forwarding_voicemail
		if (@sip_account)
			@always_destination    = get_call_forward( @sip_account, @cfwd_case_always_id )
			@noanswer_destination  = get_call_forward( @sip_account, @cfwd_case_noanswer_id )
			@busy_destination      = get_call_forward( @sip_account, @cfwd_case_busy_id )
			@offline_destination   = get_call_forward( @sip_account, @cfwd_case_offline_id )
		end
	end
	
	def sip_accounts
		@xml_menu_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{@mac_address}"
		@sip_accounts = @phone.sip_accounts.all
	end
	
	def index
		mfc = Manufacturer.where(:ieee_name => "SNOM Technology AG").first
		@phones = mfc ? mfc.phones : []
		
		respond_to { |format|
			format.html # index.html.erb
			format.xml  { render :xml => @phones }
		}
	end
	
	def get_sip_account(phone, sip_account_id = nil)
		sip_accounts = phone.sip_accounts
		
		if (! sip_accounts) 
			return nil
		end
		
		if (sip_account_id.blank?)
			return sip_accounts.first
		end
		
		return sip_account = sip_accounts.find_by_id( sip_account_id )
	end
	
	def get_call_forward( sip_account, reason )
		if (sip_account.nil?)
			return ''
		end
		if (call_forward = sip_account.call_forwards.where( :call_forward_reason_id => reason, :active => true, :source => '' ).first)
			return call_forward.destination.to_s
		end
		return ''
	end
	
	def save_call_forward( sip_account, reason, destination, timeout = nil )
		if (reason == @cfwd_case_noanswer_id && (! destination.blank?))
			timeout = timeout.to_i
			if (timeout < 1 || timeout > 120)
				timeout = 20
			end
		else
			timeout = nil
		end
		
		call_forward = sip_account.call_forwards.where( :call_forward_reason_id => reason, :active => true, :source => '' ).first
		if (call_forward.nil?)
			call_forward = sip_account.call_forwards.where( :call_forward_reason_id => reason, :active => false, :source => '' ).first
		end
		
		if (call_forward.nil?)
			if (! destination.blank?)
				call_forward = sip_account.call_forwards.create(
					:active => true,
					:source => '',
					:call_forward_reason_id => reason,
					:destination => destination,
					:call_timeout => timeout
				)
				if (call_forward.save)
					return true
				end
			end
		else
			if (! destination.blank?)
				call_forward_update = call_forward.update_attributes(
					:active => true,
					:destination => destination,
					:call_timeout => timeout
				)
			else
				call_forward_update = call_forward.update_attributes(
					:active => false,
				)
			end
		end
		
		return call_forward_update
	end
	
	def get_user_by_phone(phone)
		sip_accounts = phone.sip_accounts
		
		if (! sip_accounts) 
			return nil
		end
		
		sip_accounts.each do |sip_account|
			if (sip_account.user)
				return sip_account.user
			end
		end
		
		return nil
	end
	
	private
	DISPOSITION_NOANSWER = 'noanswer'
	DISPOSITION_ANSWERED = 'answered'
	DISPOSITION_FORWARDED = 'forwarded'
	CALL_INBOUND = 'in'
	CALL_OUTBOUND = 'out'
	DISPLAY_MAX_ENTRIES = 20
end
