xml.instruct!

xml.document(:type => 'freeswitch/xml') {

	xml.tag!('X-PRE-PROCESS', :cmd => 'set', :data => 'sound_prefix=$${sounds_dir}/en/us/callie')

	xml.section(:name => 'configuration', :description => 'FreeSWITCH configuration generated by Gemeinschaft 4') {
		xml.configuration(:name => 'acl.conf', :description => 'Network Lists') {
			xml.tag!('network-lists') {
				xml.list(:name => 'domains', :default => 'deny') {
					xml.node(:type => 'allow', :domain => "#{@domain}")
					xml.node(:type => 'allow', :cidr => '127.0.0.1/32')
				}
			}
		}
		
		xml.configuration(:name => 'cdr_csv.conf', :description => 'CDR CSV Format') {
			xml.settings {
				xml.param(:name => 'default-template', :value => 'example')
				xml.param(:name => 'rotate-on-hup', :value => 'true')
				xml.param(:name => 'legs', :value => 'a')
			}
			xml.templates {
				xml.template('INSERT INTO cdr VALUES ("${caller_id_name}","${caller_id_number}","${destination_number}","${context}","${start_stamp}","${answer_stamp}","${end_stamp}","${duration}","${billsec}","${hangup_cause}","${uuid}","${bleg_uuid}", "${accountcode}");', :name => 'sql')
				xml.template('"${caller_id_name}","${caller_id_number}","${destination_number}","${context}","${start_stamp}","${answer_stamp}","${end_stamp}","${duration}","${billsec}","${hangup_cause}","${uuid}","${bleg_uuid}","${accountcode}","${read_codec}","${write_codec}"', :name => 'example')
			}
		}
		
		xml.configuration(:name => 'conference.conf', :description => 'Audio Conference') {
			xml.advertise {
			}
			xml.tag!('caller-controls') {
				xml.group(:name => 'default') {
					xml.control(:action => 'mute', :digits => '0')
					xml.control(:action => 'deaf mute', :digits => '*')
					xml.control(:action => 'energy up', :digits => '9')
					xml.control(:action => 'energy equ', :digits => '8')
					xml.control(:action => 'energy dn', :digits => '7')
					xml.control(:action => 'vol talk up', :digits => '3')
					xml.control(:action => 'vol talk zero', :digits => '2')
					xml.control(:action => 'vol talk dn', :digits => '1')
					xml.control(:action => 'vol listen up', :digits => '6')
					xml.control(:action => 'vol listen zero', :digits => '5')
					xml.control(:action => 'vol listen dn', :digits => '4')
					xml.control(:action => 'hangup', :digits => '#')
				}
			}
			xml.profiles {
				xml.profile(:name => 'default') {
					xml.param(:name => 'domain', :value => "#{@domain}")
					xml.param(:name => 'rate', :value => '8000')
					xml.param(:name => 'interval', :value => '20')
					xml.param(:name => 'energy-level', :value => '300')
					xml.param(:name => 'sound-prefix', :value => "#{@sounds_dir}/en/us/callie")
					xml.param(:name => 'muted-sound', :value => 'conference/conf-muted.wav')
					xml.param(:name => 'unmuted-sound', :value => 'conference/conf-unmuted.wav')
					xml.param(:name => 'alone-sound', :value => 'conference/conf-alone.wav')
					xml.param(:name => 'moh-sound', :value => "#{@hold_music}")
					xml.param(:name => 'enter-sound', :value => 'tone_stream://%(200,0,500,600,700)')
					xml.param(:name => 'exit-sound', :value => 'tone_stream://%(500,0,300,200,100,50,25)')
					xml.param(:name => 'kicked-sound', :value => 'conference/conf-kicked.wav')
					xml.param(:name => 'locked-sound', :value => 'conference/conf-locked.wav')
					xml.param(:name => 'is-locked-sound', :value => 'conference/conf-is-locked.wav')
					xml.param(:name => 'is-unlocked-sound', :value => 'conference/conf-is-unlocked.wav')
					xml.param(:name => 'pin-sound', :value => 'conference/conf-pin.wav')
					xml.param(:name => 'bad-pin-sound', :value => 'conference/conf-bad-pin.wav')
					xml.param(:name => 'caller-id-name', :value => '$${outbound_caller_name}')
					xml.param(:name => 'caller-id-number', :value => '$${outbound_caller_id}')
					xml.param(:name => 'comfort-noise', :value => 'true')
				}
			}
		}

		xml.configuration(:name => 'console.conf', :description => 'Console Logger') {
			xml.mappings {
				xml.map(:name => 'all', :value => 'console,debug,info,notice,warning,err,crit,alert')
			}
			xml.settings {
				xml.param(:name => 'colorize', :value => 'true')
				xml.param(:name => 'loglevel', :value => 'debug')
			}
		}

		xml.configuration(:name => 'event_socket.conf', :description => 'Socket Client') {
			xml.settings {
				xml.param(:name => 'nat-map', :value => 'false')
				xml.param(:name => 'listen-ip', :value => '127.0.0.1')
				xml.param(:name => 'listen-port', :value => '8021')
				xml.param(:name => 'password', :value => '')
				xml.param(:name => 'apply-inbound-acl', :value => '127.0.0.1/32')
			}
		}

		xml.configuration(:name => 'fifo.conf', :description => 'FIFO Configuration') {
			xml.settings {
				xml.param(:name => 'delete-all-outbound-member-on-startup', :value => 'false')
			}
			xml.fifos {
			}
		}

		xml.configuration(:name => 'local_stream.conf', :description => 'stream files from local dir') {
			xml.directory(:name => 'default', :path => "#{@sounds_dir}/music/8000") {
				xml.param(:name => 'rate', :value => '8000')
				xml.param(:name => 'shuffle', :value => 'true')
				xml.param(:name => 'channels', :value => '1')
				xml.param(:name => 'interval', :value => '20')
				xml.param(:name => 'timer-name', :value => 'soft')
			}
		}

		xml.configuration(:name => 'logfile.conf', :description => 'File Logging') {
			xml.settings {
				xml.param(:name => 'rotate-on-hup', :value => 'true')
			}
			xml.profiles {
				xml.profile(:name => 'default') {
					xml.settings {
						xml.param(:name => 'logfile', :value => '/var/log/freeswitch.log')
						xml.param(:name => 'rollover', :value => '10485760')
					}
					xml.mappings {
						xml.map(:name => 'all', :value => 'debug,info,notice,warning,err,crit,alert')
					}
				}
			}
		}

		xml.configuration(:name => 'xml_rpc.conf', :description => 'XML RPC') {
			xml.settings {
				xml.param(:name => 'http-port', :value => '8080')
				xml.param(:name => 'auth-realm', :value => 'freeswitch')
				xml.param(:name => 'auth-user', :value => 'freeswitch')
				xml.param(:name => 'auth-pass', :value => 'works')
			}
		}

		xml.configuration(:name => 'xml_curl.conf', :description => 'cURL XML Gateway') {
			xml.bindings {
				xml.binding(:name => 'our users directory') {
					xml.param(:name => 'gateway-url', :value => "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/freeswitch-directory-entries/search.xml", :bindings => 'directory')
					xml.param(:name => 'disable-100-continue', :value => 'true')
					xml.param(:name => 'timeout', :value => '10')
				}
			}
		}

		xml.configuration(:name => 'spidermonkey.conf', :description => 'Spider Monkey JavaScript Plug-Ins') {
			xml.modules {
				xml.tag!('load', :module => 'mod_spidermonkey_teletone')
				xml.tag!('load', :module => 'mod_spidermonkey_core_db')
				xml.tag!('load', :module => 'mod_spidermonkey_socket')
				xml.tag!('load', :module => 'mod_spidermonkey_curl')
			}
		}

		xml.configuration(:name => 'switch.conf', :description => 'Core Configuration') {
			xml.tag!('cli-keybindings') {
				xml.key(:name => '1', :value => 'help')
				xml.key(:name => '2', :value => 'status')
				xml.key(:name => '3', :value => 'show channels')
				xml.key(:name => '4', :value => 'show calls')
				xml.key(:name => '5', :value => 'sofia status')
				xml.key(:name => '6', :value => 'reloadxml')
				xml.key(:name => '7', :value => 'console loglevel 0')
				xml.key(:name => '8', :value => 'console loglevel 7')
				xml.key(:name => '9', :value => 'sofia status profile internal')
				xml.key(:name => '10', :value => 'sofia profile internal siptrace on')
				xml.key(:name => '11', :value => 'sofia profile internal siptrace off')
				xml.key(:name => '12', :value => 'version')
			}
			xml.settings {
				xml.param(:name => 'colorize-console', :value => 'true')
				xml.param(:name => 'max-sessions', :value => '1000')
				xml.param(:name => 'sessions-per-second', :value => '30')
				xml.param(:name => 'loglevel', :value => 'debug')
				xml.param(:name => 'mailer-app', :value => 'sendmail')
				xml.param(:name => 'mailer-app-args', :value => '-t')
				xml.param(:name => 'dump-cores', :value => 'yes')
				xml.param(:name => 'rtp-enable-zrtp', :value => 'true')
			}
		}

		xml.configuration(:name => 'modules.conf', :description => 'Modules') {
			xml.modules {
				xml.tag!('load', :module => 'mod_console')
				xml.tag!('load', :module => 'mod_logfile')
				xml.tag!('load', :module => 'mod_xml_rpc')
				xml.tag!('load', :module => 'mod_xml_curl')
				xml.tag!('load', :module => 'mod_cdr_csv')
				xml.tag!('load', :module => 'mod_event_socket')
				xml.tag!('load', :module => 'mod_sofia')
				xml.tag!('load', :module => 'mod_loopback')
				xml.tag!('load', :module => 'mod_commands')
				xml.tag!('load', :module => 'mod_conference')
				xml.tag!('load', :module => 'mod_dptools')
				xml.tag!('load', :module => 'mod_expr')
				xml.tag!('load', :module => 'mod_fifo')
				xml.tag!('load', :module => 'mod_voicemail')
				xml.tag!('load', :module => 'mod_limit')
				xml.tag!('load', :module => 'mod_esf')
				xml.tag!('load', :module => 'mod_fsv')
				xml.tag!('load', :module => 'mod_valet_parking')
				xml.tag!('load', :module => 'mod_curl')
				xml.tag!('load', :module => 'mod_dialplan_xml')
				xml.tag!('load', :module => 'mod_voipcodecs')
				xml.tag!('load', :module => 'mod_sndfile')
				xml.tag!('load', :module => 'mod_native_file')
				xml.tag!('load', :module => 'mod_local_stream')
				xml.tag!('load', :module => 'mod_tone_stream')
				xml.tag!('load', :module => 'mod_file_string')
				xml.tag!('load', :module => 'mod_spidermonkey')
				xml.tag!('load', :module => 'mod_lua')
				xml.tag!('load', :module => 'mod_say_en')
			}
		}

		xml.configuration(:name => 'post_load_modules.conf', :description => 'Modules') {
			xml.modules {
			}
		}

		

		xml.configuration(:name => 'timezones.conf', :description => 'Timezones') {
			xml.timezones {
				@timezones.each_pair do |name, value|
					xml.zone(:name => name, :value => value)
				end
			}
		}

		

		xml.configuration(:name => 'voicemail.conf', :description => 'Voicemail') {
			xml.settings {
			}
			xml.profiles {
				xml.profile(:name => 'default') {
					xml.param(:name => 'file-extension', :value => 'wav')
					xml.param(:name => 'terminator-key', :value => '#')
					xml.param(:name => 'max-login-attempts', :value => '3')
					xml.param(:name => 'digit-timeout', :value => '10000')
					xml.param(:name => 'min-record-len', :value => '3')
					xml.param(:name => 'max-record-len', :value => '300')
					xml.param(:name => 'max-retries', :value => '3')
					xml.param(:name => 'tone-spec', :value => '%(1000, 0, 640)')
					xml.param(:name => 'callback-dialplan', :value => 'XML')
					xml.param(:name => 'callback-context', :value => 'default')
					xml.param(:name => 'play-new-messages-key', :value => '1')
					xml.param(:name => 'play-saved-messages-key', :value => '2')
					xml.param(:name => 'login-keys', :value => '0')
					xml.param(:name => 'main-menu-key', :value => '0')
					xml.param(:name => 'config-menu-key', :value => '5')
					xml.param(:name => 'record-greeting-key', :value => '1')
					xml.param(:name => 'choose-greeting-key', :value => '2')
					xml.param(:name => 'change-pass-key', :value => '6')
					xml.param(:name => 'record-name-key', :value => '3')
					xml.param(:name => 'record-file-key', :value => '3')
					xml.param(:name => 'listen-file-key', :value => '1')
					xml.param(:name => 'save-file-key', :value => '2')
					xml.param(:name => 'delete-file-key', :value => '7')
					xml.param(:name => 'undelete-file-key', :value => '8')
					xml.param(:name => 'email-key', :value => '4')
					xml.param(:name => 'pause-key', :value => '0')
					xml.param(:name => 'restart-key', :value => '1')
					xml.param(:name => 'ff-key', :value => '6')
					xml.param(:name => 'rew-key', :value => '4')
					xml.param(:name => 'skip-greet-key', :value => '#')
					xml.param(:name => 'record-silence-threshold', :value => '200')
					xml.param(:name => 'record-silence-hits', :value => '2')
					xml.param(:name => 'web-template-file', :value => 'web-vm.tpl')
					xml.param(:name => 'operator-extension', :value => 'operator XML default')
					xml.param(:name => 'operator-key', :value => '9')
					xml.param(:name => 'vmain-extension', :value => 'vmain XML default')
					xml.param(:name => 'vmain-key', :value => '*')
					xml.email {
						xml.param(:name => 'notify-template-file', :value => 'notify-voicemail.tpl')
						xml.param(:name => 'template-file', :value => 'voicemail.tpl')
						xml.param(:name => 'date-fmt', :value => '%A, %B %d %Y, %I %M %p')
						xml.param(:name => 'email-from', :value => '${voicemail_account}@${voicemail_domain}')
					}
				}
			}

		}

		xml.configuration(:name => 'sofia.conf', :description => 'sofia Configuration') {
			xml.global_settings {
				xml.param(:name => 'log-level', :value => '0')
				xml.param(:name => 'debug-presence', :value => '0')
			}
			xml.profiles {
				xml.profile(:name => 'internal') {
					xml.aliases {
					}
					xml.gateways {
					}
					xml.domains {
						xml.domain(:name => 'all', :alias => 'true', :parse => 'false')
					}
					xml.settings {
						xml.param(:name => 'user-agent-string', :value => 'Gemeinschaft4')
						xml.param(:name => 'debug', :value => '0')
						xml.param(:name => 'sip-trace', :value => 'no')
						xml.param(:name => 'log-auth-failures', :value => 'true')
						xml.param(:name => 'context', :value => 'internal')
						xml.param(:name => 'rfc2833-pt', :value => '101')
						xml.param(:name => 'sip-port', :value => "#{@internal_sip_port}")
						xml.param(:name => 'dialplan', :value => 'XML')
						xml.param(:name => 'dtmf-duration', :value => '2000')
						xml.param(:name => 'inbound-codec-prefs', :value => 'PCMA,PCMU,GSM')
						xml.param(:name => 'outbound-codec-prefs', :value => 'PCMA,PCMU,GSM')
						xml.param(:name => 'rtp-timer-name', :value => '')
						xml.param(:name => 'rtp-ip', :value => "#{@local_ip}")
						xml.param(:name => 'sip-ip', :value => '127.0.0.1')
						xml.param(:name => 'hold-music', :value => "#{@hold_music}")
						xml.param(:name => 'apply-nat-acl', :value => 'nat.auto')
						xml.param(:name => 'apply-inbound-acl', :value => 'domains')
						xml.param(:name => 'local-network-acl', :value => 'localnet.auto')
						xml.param(:name => 'manage-presence', :value => 'true')
						xml.param(:name => 'inbound-codec-negotiation', :value => 'generous')
						xml.param(:name => 'tls', :value => 'false')
						xml.param(:name => 'accept-blind-reg', :value => 'false')
						xml.param(:name => 'accept-blind-auth', :value => 'false')
						xml.param(:name => 'nonce-ttl', :value => '60')
						xml.param(:name => 'disable-transcoding', :value => 'false')
						xml.param(:name => 'manual-redirect', :value => 'true')
						xml.param(:name => 'disable-transfer', :value => 'false')
						xml.param(:name => 'disable-register', :value => 'false')
						xml.param(:name => 'auth-calls', :value => 'true')
						xml.param(:name => 'inbound-reg-force-matching-username', :value => 'true')
						xml.param(:name => 'auth-all-packets', :value => 'false')
						xml.param(:name => 'ext-rtp-ip', :value => 'auto-nat')
						xml.param(:name => 'ext-sip-ip', :value => 'auto-nat')
						xml.param(:name => 'rtp-timeout-sec', :value => '300')
						xml.param(:name => 'rtp-hold-timeout-sec', :value => '1800')
						xml.param(:name => 'force-subscription-expires', :value => '120')
						xml.param(:name => 'challenge-realm', :value => 'auto_from')
					}
				}
				xml.profile(:name => 'external') {
					xml.aliases {
					}
					xml.gateways {
					}
					xml.domains {
						xml.domain(:name => 'all', :alias => 'false', :parse => 'true')
					}
					xml.settings {
						xml.param(:name => 'user-agent-string', :value => 'Gemeinschaft4')
						xml.param(:name => 'debug', :value => '0')
						xml.param(:name => 'sip-trace', :value => 'no')
						xml.param(:name => 'rfc2833-pt', :value => '101')
						xml.param(:name => 'sip-port', :value => "#{@external_sip_port}")
						xml.param(:name => 'dialplan', :value => 'XML')
						xml.param(:name => 'context', :value => 'public')
						xml.param(:name => 'dtmf-duration', :value => '2000')
						xml.param(:name => 'inbound-codec-prefs', :value => 'PCMA,PCMU,GSM')
						xml.param(:name => 'outbound-codec-prefs', :value => 'PCMA,PCMU,GSM')
						xml.param(:name => 'hold-music', :value => "#{@hold_music}")
						xml.param(:name => 'rtp-timer-name', :value => 'soft')
						xml.param(:name => 'local-network-acl', :value => 'localnet.auto')
						xml.param(:name => 'manage-presence', :value => 'false')
						xml.param(:name => 'inbound-codec-negotiation', :value => 'generous')
						xml.param(:name => 'nonce-ttl', :value => '60')
						xml.param(:name => 'auth-calls', :value => 'false')
						xml.param(:name => 'rtp-ip', :value => "#{@local_ip}")
						xml.param(:name => 'sip-ip', :value => '127.0.0.1')
						xml.param(:name => 'ext-rtp-ip', :value => 'auto-nat')
						xml.param(:name => 'ext-sip-ip', :value => 'auto-nat')
						xml.param(:name => 'rtp-timeout-sec', :value => '300')
						xml.param(:name => 'rtp-hold-timeout-sec', :value => '1800')
						xml.param(:name => 'tls', :value => 'false')
					}
				}
			}
		}
	}

	xml.section(:name => 'dialplan', :description => 'Regex/XML dialplan') {
		xml.context(:name => 'internal') {
			xml.extension(:name => 'from-kamailio') {
				xml.condition(:field => 'network_addr', :expression => '^127\.0\.0\.1$')
				xml.condition(:field => 'destination_number', :expression => '^(.+)$') {
					xml.action(:application => 'transfer', :data => '$1 XML default')
				}
			}
		}
		xml.context(:name => 'default') {
			xml.extension(:name => 'unloop') {
				xml.condition(:field => '${unroll_loops}', :expression => '^true$')
				xml.condition(:field => '${sip_looped_call}', :expression => '^true$') {
					xml.action(:application => 'deflect', :data => '${destination_number}')
				}
			}
			xml.extension(:name => 'kam-park-in') {
				xml.condition(:field => 'destination_number', :expression => '^-park-in-$') {
					xml.action(:application => 'valet_park', :data => 'valet_lot auto in 8000 8999')
				}
			}
			xml.extension(:name => 'kam-park-out') {
				xml.condition(:field => 'destination_number', :expression => '^-park-out-$') {
					xml.action(:application => 'answer')
					xml.action(:application => 'valet_park', :data => 'valet_lot ask 4 4 10000 ivr/ivr-enter_ext_pound.wav')
				}
			}
			xml.extension(:name => 'kam-queue-login') {
				xml.condition(:field => 'destination_number', :expression => '^-queue-login-(.*)$') {
					xml.action(:application => 'answer')
					xml.action(:application => 'set', :data => 'result=${fifo_member(add $1 {fifo_member_wait=nowait}user/${sip_from_user}@${domain_name}}')
					xml.action(:application => 'playback', :data => 'ivr/ivr-you_are_now_logged_in.wav')
				}
			}
			xml.extension(:name => 'kam-queue-logout') {
				xml.condition(:field => 'destination_number', :expression => '^-queue-logout-(.*)$') {
					xml.action(:application => 'answer')
					xml.action(:application => 'set', :data => 'result=${fifo_member(del $1 {fifo_member_wait=nowait}user/${sip_from_user}@${domain_name}}')
					xml.action(:application => 'playback', :data => 'ivr/ivr-you_are_now_logged_out.wav')
				}
			}
			xml.extension(:name => 'kam-queue-in') {
				xml.condition(:field => 'destination_number', :expression => '^-kambridge-(-queue-.*)$') {
					xml.action(:application => 'answer')
					xml.action(:application => 'playback', :data => 'ivr/ivr-hold_connect_call.wav')
					xml.action(:application => 'fifo', :data => '$1 in')
				}
			}
			xml.extension(:name => 'kam-vbox') {
				xml.condition(:field => 'destination_number', :expression => '^-vbox-(.+)$') {
					xml.action(:application => 'answer', :data => 'voicemail_authorized=true')
					xml.action(:application => 'voicemail', :data => 'default ${domain_name} $1')
				}
			}
			xml.extension(:name => 'kam-vmenu-self') {
				xml.condition(:field => 'destination_number', :expression => '^-vmenu-$') {
					xml.action(:application => 'log', :data => 'INFO [GS] User ${sip_from_user}@${domain_name} is checking the voicemail ...')
					xml.action(:application => 'set', :data => 'voicemail_authorized=true')
					xml.action(:application => 'voicemail', :data => 'check default ${domain_name} ${sip_from_user}')
				}
			}
			xml.extension(:name => 'gs-main') {
				xml.condition(:field => '${module_exists(mod_spidermonkey)}', :expression => 'true')
				xml.condition(:field => 'destination_number', :expression => '^-kambridge-(.+)$') {
					xml.action(:application => 'javascript', :data => 'GS.js')
					xml.action(:application => 'hangup', :data => 'NORMAL_TEMPORARY_FAILURE')
				}
			}
		}
	}

}