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
		
		sip_account =  @phone.sip_accounts.first
		if (! sip_account.nil?)
			xml.alert_group_ring_text(@phone.sip_accounts.first.auth_name, :perm => 'RW')
		else
			xml.alert_group_ring_text('alert-group', :perm => 'RW')
		end
		xml.alert_group_ring_sound('Silent', :perm => 'RW')

		xml.dkey_directory( "url #{@provisioning_server_url}/phone_book_internal.xml", :perm => 'RW' )	
		xml.dkey_menu( "url #{@provisioning_server_url}/xml_menu.xml", :perm => 'RW' )
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
				:name                     => (is_defined ? sact.auth_name                : ''  ),
				:phone_id                 => (is_defined ? sact.phone_id                 : nil ),
				:auth_user                => (is_defined ? sact.auth_name                : ''  ),
				:user                     => (is_defined ? sact.auth_name                : ''  ),
				:password                 => (is_defined ? sact.password                 : ''  ),
				:registrar                => (is_defined ? sact.sip_proxy.host           : nil ),
				:registrar_port           => (is_defined ? sact.sip_proxy.port           : nil ),
				:outbound_proxy           => (is_defined ? sact.sip_proxy.host           : nil ),
				:outbound_proxy_port      => (is_defined ? sact.sip_proxy.port           : nil ),
				:sip_proxy                => (is_defined ? sact.sip_proxy.host           : nil ),
				:sip_proxy_port           => (is_defined ? sact.sip_proxy.port           : nil ),
				:realm                    => (is_defined ? sact.realm                    : nil ),
				:screen_name              => (is_defined ? sact.caller_name              : nil ),
				:display_name             => (is_defined ? sact.caller_name              : nil ),
				:registration_expiry_time => 3600,
				:dtmf_mode                => 'rfc2833',
				:remote_password          => (is_defined ? sact.password          : nil ),
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
			xml.user_srtp(              'off'                 , saopts_rw )
			xml.user_savp(              'off'                 , saopts_rw )
			xml.codec_size(             '20'                  , saopts_rw )
			
			codec_i = 1
			max_codec_i = 7
			@codec_mapping_snom.each do |codec_name, codec_id|
				xml.tag! "codec#{codec_i}_name", codec_id.to_s, saopts_rw
				codec_i += 1
				break if codec_i > max_codec_i
			end
		}
	end
	
	
	xml.comment! "function keys"  # <!-- a comment -->
	xml.tag! 'functionKeys' do
		
		softkeys = []
		
		@phone.phone_model.phone_model_keys.each { |phone_key|
			softkeys << {
				:pos     => phone_key.position,
				:type    => 'none',
				:val     => '',
			#	:label   => phone_key.label,
				:acctidx => 1,
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
