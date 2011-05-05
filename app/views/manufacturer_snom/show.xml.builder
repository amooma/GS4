codec_mapping_snom = @codec_mapping_snom  # defined in the controller

xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.settings {
	
	xml.tag! 'phone-settings' do
		xml.web_language( 'English', :perm => 'RW' )
		xml.timezone( 'GMT+1', :perm => 'RW' )
		xml.date_us_format( 'off', :perm => 'RW' )
		xml.time_24_format( 'on', :perm => 'RW' )
		
		xml.update_policy( 'settings_only', :perm => 'RW' )
		xml.firmware_status( '', :perm => 'RW' )
		
		xml.webserver_type( 'http_https', :perm => 'R' )
		xml.http_scheme( 'off', :perm => 'RW' )  # off = Basic, on = Digest
		xml.http_port( '80', :perm => 'R' )
		xml.https_port( '443', :perm => 'R' )
		xml.http_user( @phone.http_user.to_s, :perm => 'R' )
		xml.http_pass( @phone.http_password.to_s, :perm => 'R' )
		
		xml.retry_after_failed_register( '70', :perm => 'RW' )
		xml.encode_display_name( 'on', :perm => 'R' )
		xml.dtmf_payload_type( '101', :perm => 'RW' )
		
		
		sip_accounts = {}
		snom_sip_acct_idx = 0
		@phone.sip_accounts.each { |sip_account|
			# The sip_account.position which we get from the database
			# is an arbitrary index but for the Snom we need the index
			# to be from 1 to 4, 7 or 12, depending on the phone model.
			#snom_sip_acct_idx = sip_account.position
			snom_sip_acct_idx += 1
			sip_accounts[snom_sip_acct_idx] = sip_account
		}
		
		max_sip_acct_idx = 12
		(1..max_sip_acct_idx).each { |idx|
			is_defined = (sip_accounts[idx] ? true : false)
			sact = sip_accounts[idx]
			sac = {
				:id                       => (is_defined ? sact.id                       : nil ),
				:name                     => (is_defined ? sact.name                     : ''  ),
				:phone_id                 => (is_defined ? sact.phone_id                 : nil ),
				:auth_user                => (is_defined ? sact.auth_user                : ''  ),
				:user                     => (is_defined ? sact.user                     : ''  ),
				:password                 => (is_defined ? sact.password                 : ''  ),
				:registrar                => (is_defined ? sact.registrar                : nil ),
				:registrar_port           => (is_defined ? sact.registrar_port           : nil ),
				:outbound_proxy           => (is_defined ? sact.outbound_proxy           : nil ),
				:outbound_proxy_port      => (is_defined ? sact.outbound_proxy_port      : nil ),
				:sip_proxy                => (is_defined ? sact.sip_proxy                : nil ),
				:sip_proxy_port           => (is_defined ? sact.sip_proxy_port           : nil ),
				:realm                    => (is_defined ? sact.realm                    : nil ),
				:screen_name              => (is_defined ? sact.screen_name              : nil ),
				:display_name             => (is_defined ? sact.display_name             : nil ),
				:registration_expiry_time => (is_defined ? sact.registration_expiry_time : nil ),
				:dtmf_mode                => (is_defined ? sact.dtmf_mode                : nil ),
				:remote_password          => (is_defined ? sact.remote_password          : nil ),
				:position                 => (is_defined ? sact.position                 : nil ),
			}
			
			saopts_r  = { :idx => idx, :perm => 'R'  }
			saopts_rw = { :idx => idx, :perm => 'RW' }
							
			xml.comment! "SIP account idx #{idx}, position #{sac[:position].inspect}"  # <!-- a comment -->
			xml.user_active(            (is_defined ? 'on' : 'off') , saopts_r )
			xml.user_pname(             sac[:auth_user]       , saopts_r  )
			xml.user_pass(              sac[:password]        , saopts_r  )
			xml.user_host(              sac[:registrar]       , saopts_r  )
			xml.user_outbound(          sac[:outbound_proxy]  , saopts_r  )
			xml.user_name(              sac[:user]            , saopts_r  )
			xml.user_realname(          sac[:display_name]    , saopts_r  )
			xml.user_idle_text(         sac[:screen_name]     , saopts_r  )
			xml.user_expiry(            sac[:registration_expiry_time] || 3600 , saopts_r )
			xml.user_server_type(       'default'             , saopts_rw )
			xml.user_send_local_name(   'on'                  , saopts_rw )
			xml.user_dtmf_info(         sac[:dtmf_mode] == 'rfc2833' ? 'off' : 'sip_info_only' , saopts_r )
			xml.user_dp_exp(            ''                    , saopts_rw )
			xml.user_dp_str(            ''                    , saopts_rw )
			xml.user_dp(                ''                    , saopts_rw )
			xml.user_q(                 '1.0'                 , saopts_rw )
			xml.user_failover_identity( 'none'                , saopts_rw )
			# sac.realm
			# sac.registrar_port
			# sac.outbound_proxy_port
			# sac.sip_proxy_port
			# sac.sip_proxy
			# sac.remote_password
			
			xml.user_full_sdp_answer(   'on'                  , saopts_rw )
			xml.user_dynamic_payload(   'on'                  , saopts_rw ) # "Turns on dynamic payload type for G726."
			xml.user_g726_packing_order('on'                  , saopts_r  ) # on = RFC 3551, off = AAL2
			xml.codec_size(             '20'                  , saopts_rw )
			
			xml.comment! "codecs for SIP account idx #{idx}, position #{sac[:position].inspect}"  # <!-- a comment -->
			# See http://wiki.snom.com/Settings/codec_name
			# (Note: Snom's documentation is wrong.)
			sac_codec_names = ( is_defined ? sact.codecs.all.map{|r| r.name } : [] )
			snom_codec_i = 1
			max_snom_codec_i = 7
			sac_codec_names.each { |codec_name|
				snom_codec_name = codec_mapping_snom[codec_name]
				if (! snom_codec_name.blank?)
					xml.tag! "codec#{snom_codec_i}_name", snom_codec_name.to_s, saopts_r
					snom_codec_i += 1
					break if snom_codec_i > max_snom_codec_i
				end
			}
			if snom_codec_i <= max_snom_codec_i
				while snom_codec_i <= max_snom_codec_i
					snom_codec_name = ''  # Snom didn't document what to put here.
					xml.tag! "codec#{snom_codec_i}_name", snom_codec_name.to_s, saopts_r
					snom_codec_i += 1
				end
			end
		}
	end
	
	
	xml.comment! "function keys"  # <!-- a comment -->
	xml.tag! 'functionKeys' do
		
		softkeys = []
		snom_sip_acct_idx = 0
		@phone.sip_accounts.each { |sip_account|
			#snom_sip_acct_idx = sip_account.position
			snom_sip_acct_idx += 1
			# Let's hope that we get the sip_accounts in the same
			# order as above.
			# Here we know the sip_account .
			sip_account.phone_keys.each { |phone_key|
				# Here we know phone_key.value .
				# Here we know phone_key.phone_model_key.position .
				# Here we know phone_key.phone_key_function_definition.name .
				type = case (phone_key.phone_key_function_definition ? phone_key.phone_key_function_definition.name.downcase : nil)
					when 'blf'              ; 'blf' # or 'dest'
					when 'speed dial'       ; 'speed'
					when 'actionurl'        ; 'url'
					when 'line'             ; 'line'
					when 'phone-spec. fn.'  ; 'none'  # or nil to make it undefined
					when 'label'            ; 'none'  # or nil to make it undefined
					when 'xml'              ; 'xml'
					when 'intercom'         ; 'icom'
					when 'parking'          ; 'orbit'
					when 'recording'        ; 'recorder'
					when 'dtmf'             ; 'dtmf'
					when 'ptt'              ; 'p2t'
					when 'button'           ; 'button'
					when 'presence'         ; 'presence'
					when 'transfer'         ; 'transfer'
					when 'redirect'         ; 'redirect'
					when 'auto-answer'      ; 'autoanswer'
					when 'def. function?'   ; 'none'  # or nil to make it undefined
					else                    ; 'none'  # or nil to make it undefined
						# Someone renamed a PhoneKeyFunctionDefinition.
				end
				softkeys << {
					:pos     => (phone_key.phone_model_key ? phone_key.phone_model_key.position : nil),
					:type    => type,
					:val     => phone_key.value,
				#	:label   => phone_key.label,
					:acctidx => snom_sip_acct_idx,
				}
			}
		}
		
		snom_softkeys = {}
		softkeys.each { |softkey|
			if softkey[:pos] != nil
				snom_softkeys[softkey[:pos]] = {
					:type    => softkey[:type    ],
					:val     => softkey[:val     ],
				#	:label   => softkey[:label   ],
					:acctidx => softkey[:acctidx ],
				}
			end
		}
		
		max_key_idx = 12 + (42 * 3) - 1
		(0..max_key_idx).each { |idx|
			snom_softkey = snom_softkeys[idx] || {
				:type    => nil,
				:val     => '',
			#	:label   => '',
				:acctidx => nil,
			}
			is_defined = (snom_softkey[:type] != nil)
			xml.comment! "P #{1+idx}:"  # <!-- a comment -->
			type = (snom_softkey[:type] || 'none')
			kdef = type
			if type != 'none'
				kdef << ' ' << snom_softkey[:val]
			end
			xml.fkey( kdef,
				:idx     => idx,
				:context => (snom_softkey[:acctidx].to_i > 0) ? snom_softkey[:acctidx] : 'active',
			#	:label   => snom_softkey[:label],
				:perm    => is_defined ? 'R' : 'RW', 
			)
		}
	end
	
}


# Local Variables:
# mode: ruby
# End:
