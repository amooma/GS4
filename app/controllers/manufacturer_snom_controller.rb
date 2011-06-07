class ManufacturerSnomController < ApplicationController
	
	#TODO Authentication
	
	#OPTIMIZE Do not set @provisioning_server_url a dozen times. Use a before_filter!
	# Same goes for mac_address and @sip_account_name.
	#before_filter { |controller|
	#	@provisioning_server_url = "..."
	#}
	
	def show
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@phone = Phone.where(:mac_address => mac_address).first
		@my_local_ip = local_ip
		
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
		
		if (! @phone.nil?)  #OPTIMIZE Simply write: if (@phone)
			if (! request.env['HTTP_USER_AGENT'].index("snom").nil?)
				@phone.provisioning_log_entries.create(:succeeded => true, :memo => "Phone got config")
				@phone.update_attributes(:ip_address => request.remote_ip)
			end
			@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}"
			respond_to { |format|
				format.xml
			}
		else
			#respond_to { |format|
			#	format.html
			#}
			render(
				:status => 404,
				:layout => false,
				:content_type => 'text/plain',
				:text => "<!-- Phone #{mac_address.inspect} not found. -->",
			)
		end
	end
	
	def xml_menu
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		sip_accounts = Phone.find_by_mac_address( mac_address ).sip_accounts  #FIXME Phone.find_by_mac_address( mac_address ) can be nil. (=> pko)
		@sip_account_name = get_sip_account_name()
		@sip_accounts_count = sip_accounts.count
		@sip_account_url = "/#{@sip_account_name}"
		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}"
	end
	
	def phone_book_internal
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}"
		@sip_accounts = SipAccount.all
	end
	
	def call_forwarding
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@sip_account_name = get_sip_account_name()
		
		call_forward_always    = get_call_forward( @sip_account_name, GS_CALLFORWARD_ALWAYS )
		call_forward_noanswer  = get_call_forward( @sip_account_name, GS_CALLFORWARD_NOANSWER )
		call_forward_busy      = get_call_forward( @sip_account_name, GS_CALLFORWARD_BUSY )
		call_forward_offline   = get_call_forward( @sip_account_name, GS_CALLFORWARD_OFFLINE )
		
		@always_destination    = destination_s( call_forward_always )
		@noanswer_destination  = destination_s( call_forward_noanswer )
		@busy_destination      = destination_s( call_forward_busy )
		@offline_destination   = destination_s( call_forward_offline )
		
		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}/#{@sip_account_name}"
	end
	
	#OPTIMIZE Code smell: Duplicated code in call_forwarding_{always|busy|offline|noanswer}
	
	def call_forwarding_always
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@sip_account_name = get_sip_account_name()
		
		call_forward_always = get_call_forward( @sip_account_name, GS_CALLFORWARD_ALWAYS )
		@always_destination = destination_s( call_forward_always )

		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}/#{@sip_account_name}"
	end
	
	def call_forwarding_busy
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@sip_account_name = get_sip_account_name()
		
		call_forward_busy = get_call_forward( @sip_account_name, GS_CALLFORWARD_BUSY )
		@busy_destination = destination_s( call_forward_busy )

		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}/#{@sip_account}"
		#FIXME Typo? Should @sip_account be @sip_account_name ? (=> pko)
	end
	
	def call_forwarding_offline
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@sip_account_name = get_sip_account_name()
		
		call_forward_offline = get_call_forward( @sip_account_name, GS_CALLFORWARD_OFFLINE )
		@offline_destination = destination_s( call_forward_offline )

		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}/#{@sip_account_name}"
	end
	
	def call_forwarding_noanswer
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		if (params[:query_timeout] == '1')
			@query_timeout = true
		else
			@query_timeout = false
		end
		@sip_account_name = get_sip_account_name()
		@destination = params[:noanswer_destination].to_s.gsub(/[^0-9\*\#]/,'')
		
		call_forward_noanswer = get_call_forward( @sip_account_name, GS_CALLFORWARD_NOANSWER )
		@noanswer_destination = destination_s( call_forward_noanswer )
		@noanswer_timeout = 20
		
		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}/#{@sip_account_name}"
	end
	
	def call_forwarding_save
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@sip_account_name = get_sip_account_name()
		reason = nil
		timeout = nil
		
		#OPTIMIZE Remove the "{always|busy|offline|noanswer}_destination" params. Use a "case" param and a "destination" param.
		if (! params[:always_destination].nil?)         #OPTIMIZE Simply write: if (params[:always_destination])
			@title = "Unconditional Call Forwarding"
			reason = GS_CALLFORWARD_ALWAYS
			destination = params[:always_destination].to_s.gsub(/[^0-9\*\#]/,'')
		elsif (! params[:busy_destination].nil?)        #OPTIMIZE Simply write: if (params[:busy_destination])
			@title = "Call Forwarding on Busy"
			reason = GS_CALLFORWARD_BUSY
			destination = params[:busy_destination].to_s.gsub(/[^0-9\*\#]/,'')
		elsif (! params[:offline_destination].nil?)     #OPTIMIZE Simply write: if (params[:offline_destination])
			@title = "Call Forwarding on Offline"
			reason = GS_CALLFORWARD_OFFLINE
			destination = params[:offline_destination].to_s.gsub(/[^0-9\*\#]/,'')
		elsif (! params[:noanswer_destination].nil?)    #OPTIMIZE Simply write: if (params[:noanswer_destination])
			@title = "Call Forwarding on No Answer"
			reason = GS_CALLFORWARD_NOANSWER
			destination = params[:noanswer_destination].to_s.gsub(/[^0-9\*\#]/,'')
			timeout = params[:noanswer_timeout].to_s.gsub(/[^0-9]/,'')
		end
		
		if (reason.nil?)
			@message = "NOT SAVED"
			return false
		end
		
		call_forward = save_call_forward( @sip_account_name, reason, destination, timeout )
		if (call_forward)
			@message = "SAVED"
		else
			@message = "NOT SAVED"
		end
		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}/#{@sip_account_name}"
	end
	
	def sip_accounts
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@provisioning_server_url = "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/manufacturer_snom/#{mac_address}"
		@sip_accounts = Phone.find_by_mac_address( mac_address ).sip_accounts.all  #FIXME Phone.find_by_mac_address( mac_address ) can be nil. (=> pko)
	end
	
	def index
		mfc = Manufacturer.where(:ieee_name => "SNOM Technology AG").first
		@phones = mfc ? mfc.phones : []
		
		respond_to { |format|
			format.html # index.html.erb
			format.xml  { render :xml => @phones }
		}
	end
	
	private
	
	#TODO Are these meant to be IDs? Don't store them as magic numbers here. IDs may change in the DB. (=> pko)
	GS_CALLFORWARD_BUSY     = 1
	GS_CALLFORWARD_NOANSWER = 2
	GS_CALLFORWARD_OFFLINE  = 3
	GS_CALLFORWARD_ALWAYS   = 4
	
	def get_sip_account_name()
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		sip_account_name = params[:sip_account]
		sip_accounts = Phone.find_by_mac_address( mac_address ).sip_accounts  #FIXME Phone.find_by_mac_address( mac_address ) can be nil. (=> pko)
		if (sip_account_name.blank?)
			sip_account = sip_accounts.first
			if (! sip_account.blank?)
				sip_account_name = sip_account.auth_name
			end
		else
			sip_account = sip_accounts.find_by_auth_name( sip_account_name )
			if (! sip_account.blank?)
				sip_account_name = sip_account.auth_name
			else
				sip_account_name = nil
			end
		end
		return sip_account_name
	end
	
	def get_call_forward( auth_name, reason )
		sip_account = SipAccount.find_by_auth_name( auth_name )
		if (sip_account.nil?)
			return nil
		end
		call_forward = sip_account.call_forwards.where( :call_forward_reason_id => reason, :active => true, :source => '' ).first
		if (call_forward.nil?)
			call_forward = SipAccount.find_by_auth_name( auth_name ).call_forwards.where( :call_forward_reason_id => reason, :active => false, :source => '' ).first
		end
		return call_forward
	end
	
	#OPTIMIZE What is destination_s() supposed to do?
	def destination_s( call_forward )
		#FIXME Are you sure that "active?" is a valid method? Shouldn't it be "active" ? (=> pko)
		if (! call_forward.nil? && call_forward.active?)   #OPTIMIZE Simply write: if (call_forward && ...)
			return call_forward.destination.to_s
		end
		return ''
	end
	
	def save_call_forward( auth_name, reason, destination, timeout = nil )
		if (reason == GS_CALLFORWARD_NOANSWER && (! destination.blank?))
			timeout = timeout.to_i
			if (timeout < 1 || timeout > 360)
				timeout = 20
			end
		else
			timeout = nil
		end
		
		call_forward = get_call_forward( auth_name, reason )
		
		if (call_forward.nil?)
			if (! destination.blank?)
				sip_account = SipAccount.find_by_auth_name( auth_name )
				if (sip_account.nil?)
					return false
				end
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
	
end
