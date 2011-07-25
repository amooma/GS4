xml.instruct!

#OPTIMIZE Add comments (descriptions etc.) - Some could probably be salvaged from the original FreeSWITCH configuration.

xml.document( :type => 'freeswitch/xml' ) {
	
	xml.tag!( 'X-PRE-PROCESS', :cmd => 'set', :data => "domain=#{@domain}" )
	xml.tag!( 'X-PRE-PROCESS', :cmd => 'set', :data => "domain_name=#{@domain_name}" )
	xml.tag!( 'X-PRE-PROCESS', :cmd => 'set', :data => "sound_prefix=#{@sounds_dir}/en/us/callie" )
	xml.tag!( 'X-PRE-PROCESS', :cmd => 'set', :data => "hold_music=#{@hold_music}" )
	xml.tag!( 'X-PRE-PROCESS', :cmd => 'set', :data => 'use_profile=internal' )
	xml.tag!( 'X-PRE-PROCESS', :cmd => 'set', :data => 'send_silence_when_idle=400' )
	
	xml.section( :name => 'languages', :description => 'Language Management' ) {
		xml.language( :name => 'en', 'say-module' => 'en', 'sound-prefix' => '/opt/freeswitch/sounds/en/us/callie' ) {
			xml.phrases {
				xml.macros {
					xml.macro( :name => 'voicemail_hello' ) {
						xml.input( :pattern => '(.*)' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-hello.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_enter_id' ) {
						xml.input( :pattern => '(.*)' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-enter_id.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_enter_pass' ) {
						xml.input( :pattern => '(.*)' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-enter_pass.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_fail_auth' ) {
						xml.input( :pattern => '(.*)' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-fail_auth.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_goodbye' ) {
						xml.input( :pattern => '(.*)' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-goodbye.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_abort' ) {
						xml.input( :pattern => '(.*)' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-abort.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_message_count' ) {
						xml.input( :pattern => '^(1):(.*)$', :break_on_match => 'true' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-you_have.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'items' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$2.wav' ) 
								xml.action( :function => 'play-file', :data => 'voicemail/vm-message.wav' )
							}
						}
						xml.input( :pattern => '^(\d+):(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-you_have.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'items' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$2.wav' ) 
								xml.action( :function => 'play-file', :data => 'voicemail/vm-messages.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_menu' ) {
						xml.input( :pattern => '^([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-listen_new.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-listen_saved.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-advanced.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$3', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-to_exit.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$4', :method => 'pronounced', :type => 'name_phonetic' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_config_menu' ) {
						xml.input( :pattern => '^([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-to_record_greeting.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-choose_greeting.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-record_name2.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$3', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-change_password.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$4', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'execute', :data => 'sleep(100)' )
								
								xml.action( :function => 'play-file', :data => 'voicemail/vm-main_menu.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$5', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_record_name' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-record_name1.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_record_file_check' ) {
						xml.input( :pattern => '^([0-9#*]):([0-9#*]):([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-listen_to_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-save_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$3', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-rerecord.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_record_urgent_check' ) {
						xml.input( :pattern => '^([0-9#*]):([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-mark-urgent.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-continue.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_forward_prepend' ) {
						xml.input( :pattern => '^([0-9#*]):([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-forward_add_intro.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-send_message_now.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_forward_message_enter_extension' ) {
						xml.input( :pattern => '^([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-forward_enter_ext.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-followed_by.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_invalid_extension' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-that_was_an_invalid_ext.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_listen_file_check' ) {
						xml.input( :pattern => '^([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*]):(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-listen_to_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-save_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-delete_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$3', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-forward_to_email.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$4', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-return_call.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$5', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-to_forward.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$6', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
						xml.input( :pattern => '^([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*]):([0-9#*])$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-listen_to_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-save_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-delete_recording.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$3', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-return_call.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$5', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-to_forward.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-press.wav' )
								xml.action( :function => 'say', :data => '$6', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_choose_greeting' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-choose_greeting_choose.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_choose_greeting_fail' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-choose_greeting_fail.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_record_greeting' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-record_greeting.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_record_message' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-record_message.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_greeting_selected' ) {
						xml.input( :pattern => '^(\d+)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-greeting.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'items' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-selected.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_play_greeting' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-person.wav' )
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-not_available.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_say_number' ) {
						xml.input( :pattern => '^(\d+)$' ) {
							xml.match {
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'items' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_say_message_number' ) {
						xml.input( :pattern => '^([a-z]+):(\d+)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$1.wav' ) 
								xml.action( :function => 'play-file', :data => 'voicemail/vm-message_number.wav' )
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'items' ) 
							}
						}
					}
					
					xml.macro( :name => 'voicemail_say_phone_number' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_say_name' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					xml.macro( :name => 'voicemail_ack' ) {
						xml.input( :pattern => '^(too-small)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-too-small.wav' )
							}
						}
						xml.input( :pattern => '^(deleted)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-message.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$1.wav' )
							}
						}
						xml.input( :pattern => '^(saved)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-message.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$1.wav' )
							}
						}
						xml.input( :pattern => '^(emailed)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-message.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$1.wav' )
							}
						}
						xml.input( :pattern => '^(marked-urgent)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'voicemail/vm-message.wav' )
								xml.action( :function => 'play-file', :data => 'voicemail/vm-$1.wav' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_say_date' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'say', :data => '$1', :method => 'pronounced', :type => 'current_date_time' )
							}
						}
					}
					
					xml.macro( :name => 'voicemail_disk_quota_exceeded' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
									xml.action( :function => 'play-file', :data => 'voicemail/vm-mailbox_full.wav' )
							}
						}
					}
					
					xml.macro( :name => 'valet_announce_ext' ) {
						xml.input( :pattern => '^([^\:]+):(.*)$' ) {
							xml.match {
								xml.action( :function => 'say', :data => '$2', :method => 'pronounced', :type => 'name_spelled' )
							}
						}
					}
					
					xml.macro( :name => 'valet_lot_full' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'tone_stream://%(275,10,600);%(275,100,300)' )
							}
						}
					}
					
					xml.macro( :name => 'valet_lot_empty' ) {
						xml.input( :pattern => '^(.*)$' ) {
							xml.match {
								xml.action( :function => 'play-file', :data => 'tone_stream://%(275,10,600);%(275,100,300)' )
							}
						}
					}
					
				}
			}
		}
	}
	
	xml.section( :name => 'configuration', :description => 'FreeSwitch configuration generated by Gemeinschaft4' ) {
		xml.configuration( :name => 'acl.conf', :description => 'Network Lists' ) {
			xml.tag!( 'network-lists' ) {
				xml.list( :name => 'domains', :default => 'deny' ) {
					xml.node( :type => 'allow', :domain => "#{@domain}" )
					xml.node( :type => 'allow', :cidr => '127.0.0.1/32' )
				}
			}
		}
		
		xml.configuration( :name => 'cdr_csv.conf', :description => 'CDR CSV Format' ) {
			xml.settings {
				xml.param( :name => 'default-template', :value => 'example' )
				xml.param( :name => 'rotate-on-hup', :value => 'true' )
				xml.param( :name => 'legs', :value => 'a' )
			}
			xml.templates {
				xml.template( 'INSERT INTO cdr VALUES ("${caller_id_name}","${caller_id_number}","${destination_number}","${context}","${start_stamp}","${answer_stamp}","${end_stamp}","${duration}","${billsec}","${hangup_cause}","${uuid}","${bleg_uuid}", "${accountcode}");', :name => 'sql' )
				xml.template( '"${caller_id_name}","${caller_id_number}","${destination_number}","${context}","${start_stamp}","${answer_stamp}","${end_stamp}","${duration}","${billsec}","${hangup_cause}","${uuid}","${bleg_uuid}","${accountcode}","${read_codec}","${write_codec}"', :name => 'example' )
			}
		}
		
		xml.configuration( :name => 'conference.conf', :description => 'Audio Conference' ) {
			xml.advertise {
			}
			xml.tag!( 'caller-controls' ) {
				xml.group( :name => 'default' ) {
					xml.control( :action => 'mute'            )  #OPTIMIZE Is there a reason to skip :digits => '0' ?
					xml.control( :action => 'deaf mute'       , :digits => '*' )
					xml.control( :action => 'energy up'       , :digits => '9' )
					xml.control( :action => 'energy equ'      , :digits => '8' )
					xml.control( :action => 'energy dn'       , :digits => '7' )
					xml.control( :action => 'vol talk up'     , :digits => '3' )
					xml.control( :action => 'vol talk zero'   , :digits => '2' )
					xml.control( :action => 'vol talk dn'     , :digits => '1' )
					xml.control( :action => 'vol listen up'   , :digits => '6' )
					xml.control( :action => 'vol listen zero' , :digits => '5' )
					xml.control( :action => 'vol listen dn'   , :digits => '4' )
					xml.control( :action => 'hangup'          , :digits => '#' )
				}
			}
			xml.profiles {
				xml.profile( :name => 'default' ) {
					xml.param( :name => 'domain', :value => "#{@domain}" )
					xml.param( :name => 'rate', :value => '8000' )
					xml.param( :name => 'interval', :value => '20' )
					xml.param( :name => 'energy-level', :value => '300' )
					
					xml.param( :name => 'sound-prefix'      , :value => "#{@sounds_dir}/en/us/callie" )
					xml.param( :name => 'muted-sound'       , :value => 'conference/conf-muted.wav' )
					xml.param( :name => 'unmuted-sound'     , :value => 'conference/conf-unmuted.wav' )
					xml.param( :name => 'alone-sound'       , :value => 'conference/conf-alone.wav' )
					xml.param( :name => 'moh-sound'         , :value => "#{@hold_music}" )
					xml.param( :name => 'enter-sound'       , :value => 'tone_stream://%(200,0,500,600,700)' )
					xml.param( :name => 'exit-sound'        , :value => 'tone_stream://%(500,0,300,200,100,50,25)' )
					xml.param( :name => 'kicked-sound'      , :value => 'conference/conf-kicked.wav' )
					xml.param( :name => 'locked-sound'      , :value => 'conference/conf-locked.wav' )
					xml.param( :name => 'is-locked-sound'   , :value => 'conference/conf-is-locked.wav' )
					xml.param( :name => 'is-unlocked-sound' , :value => 'conference/conf-is-unlocked.wav' )
					xml.param( :name => 'pin-sound'         , :value => 'conference/conf-pin.wav' )
					xml.param( :name => 'bad-pin-sound'     , :value => 'conference/conf-bad-pin.wav' )
					
					xml.param( :name => 'caller-id-name'   , :value => '$${outbound_caller_name}' )
					xml.param( :name => 'caller-id-number' , :value => '$${outbound_caller_id}' )
					
					xml.param( :name => 'comfort-noise', :value => 'true' )
				}
			}
		}
		
		xml.configuration( :name => 'console.conf', :description => 'Console Logger' ) {
			xml.mappings {
				xml.map( :name => 'all', :value => 'console,debug,info,notice,warning,err,crit,alert' )
			}
			xml.settings {
				xml.param( :name => 'colorize', :value => 'true' )
				xml.param( :name => 'loglevel', :value => 'debug' )
			}
		}
		
		xml.configuration( :name => 'event_socket.conf', :description => 'Socket Client' ) {
			xml.settings {
				xml.param( :name => 'nat-map', :value => 'false' )
				xml.param( :name => 'listen-ip', :value => '127.0.0.1' )
				xml.param( :name => 'listen-port', :value => '8021' )
				xml.param( :name => 'password', :value => '' )
				xml.param( :name => 'apply-inbound-acl', :value => '127.0.0.1/32' )
			}
		}
		
		xml.configuration( :name => 'fifo.conf', :description => 'FIFO Configuration' ) {
			xml.settings {
				xml.param( :name => 'delete-all-outbound-member-on-startup', :value => 'false' )
			}
			xml.fifos {
			}
		}
		
		xml.configuration( :name => 'local_stream.conf', :description => 'stream files from local dir' ) {
			xml.directory( :name => 'default', :path => "#{@sounds_dir}/music/8000" ) {
				xml.param( :name => 'rate', :value => '8000' )
				xml.param( :name => 'shuffle', :value => 'true' )
				xml.param( :name => 'channels', :value => '1' )
				xml.param( :name => 'interval', :value => '20' )
				xml.param( :name => 'timer-name', :value => 'soft' )
			}
			xml.directory( :name => 'moh', :path => "#{@sounds_dir}/music/8000" ) {
				xml.param( :name => 'rate', :value => '8000' )
				xml.param( :name => 'shuffle', :value => 'true' )
				xml.param( :name => 'channels', :value => '1' )
				xml.param( :name => 'interval', :value => '20' )
				xml.param( :name => 'timer-name', :value => 'soft' )
			}
		}
		
		xml.configuration( :name => 'logfile.conf', :description => 'File Logging' ) {
			xml.settings {
				xml.param( :name => 'rotate-on-hup', :value => 'true' )
			}
			xml.profiles {
				xml.profile( :name => 'default' ) {
					xml.settings {
						xml.param( :name => 'logfile', :value => '/var/log/freeswitch.log' )
						xml.param( :name => 'rollover', :value => '10485760' )
					}
					xml.mappings {
						xml.map( :name => 'all', :value => 'debug,info,notice,warning,err,crit,alert' )
					}
				}
			}
		}
		
		xml.configuration( :name => 'xml_rpc.conf', :description => 'XML RPC' ) {
			#OPTIMIZE Ensure xml_rpc can be accessed from localhost only as there is no way to set a listen_to address here.
			xml.settings {
				xml.param( :name => 'http-port' , :value => @xml_rpc_port )
				xml.param( :name => 'auth-realm', :value => @xml_rpc_realm )
				xml.param( :name => 'auth-user' , :value => @xml_rpc_user )
				xml.param( :name => 'auth-pass' , :value => @xml_rpc_password )
			}
		}
		
		xml.configuration( :name => 'xml_curl.conf', :description => 'cURL XML Gateway' ) {
			xml.bindings {
				xml.binding( :name => 'our users directory' ) {
					xml.param( :name => 'gateway-url', :value => "http://#{request.env['SERVER_NAME']}:#{request.env['SERVER_PORT']}/freeswitch-directory-entries/search.xml", :bindings => 'directory' )
					xml.param( :name => 'disable-100-continue', :value => 'true' )
					xml.param( :name => 'timeout', :value => '10' )
				}
			}
		}
		
		xml.configuration( :name => 'spidermonkey.conf', :description => 'Spider Monkey JavaScript Plug-Ins' ) {
			xml.modules {
				xml.tag!( 'load', :module => 'mod_spidermonkey_teletone' )
				xml.tag!( 'load', :module => 'mod_spidermonkey_core_db' )
				xml.tag!( 'load', :module => 'mod_spidermonkey_socket' )
				xml.tag!( 'load', :module => 'mod_spidermonkey_curl' )
			}
		}
		
		xml.configuration( :name => 'switch.conf', :description => 'Core Configuration' ) {
			xml.tag!( 'cli-keybindings' ) {
				xml.key( :name =>  '1', :value => 'help' )
				xml.key( :name =>  '2', :value => 'status' )
				xml.key( :name =>  '3', :value => 'show channels' )
				xml.key( :name =>  '4', :value => 'show calls' )
				xml.key( :name =>  '5', :value => 'sofia status' )
				xml.key( :name =>  '6', :value => 'reloadxml' )
				xml.key( :name =>  '7', :value => 'console loglevel 0' )
				xml.key( :name =>  '8', :value => 'console loglevel 7' )
				xml.key( :name =>  '9', :value => 'sofia status profile internal' )
				xml.key( :name => '10', :value => 'sofia profile internal siptrace on' )
				xml.key( :name => '11', :value => 'sofia profile internal siptrace off' )
				xml.key( :name => '12', :value => 'version' )
			}
			xml.settings {
				xml.param( :name => 'colorize-console', :value => 'true' )
				xml.param( :name => 'max-sessions', :value => '1000' )
				xml.param( :name => 'sessions-per-second', :value => '30' )
				xml.param( :name => 'loglevel', :value => 'debug' )
				xml.param( :name => 'mailer-app', :value => 'sendmail' )
				xml.param( :name => 'mailer-app-args', :value => '-t' )
				xml.param( :name => 'dump-cores', :value => 'yes' )
				xml.param( :name => 'rtp-enable-zrtp', :value => 'true' )
			}
		}
		
		xml.configuration( :name => 'spandsp.conf', :description => 'Tone detector descriptors' ) {
			xml.descriptors {
				xml.descriptor( :name  => '1' ) {
					xml.tone( :name => 'CED_TONE' ) {
						xml.element( :freq1 => '2100', :freq2 =>   '0', :min => '500', :max =>   '0' )
					}
					xml.tone( :name => 'SIT' ) {
						xml.element( :freq1 =>  '950', :freq2 =>   '0', :min => '256', :max => '400' )
						xml.element( :freq1 => '1400', :freq2 =>   '0', :min => '256', :max => '400' )
						xml.element( :freq1 => '1800', :freq2 =>   '0', :min => '256', :max => '400' )
					}
					xml.tone( :name => 'REORDER_TONE' ) {
						xml.element( :freq1 =>  '480', :freq2 => '620', :min => '224', :max => '272' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '224', :max => '272' )
					}
					xml.tone( :name => 'BUSY_TONE' ) {
						xml.element( :freq1 =>  '480', :freq2 => '620', :min => '464', :max => '516' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '464', :max => '516' )
					}
				}
				
				xml.descriptor( :name  => '44' ) {
					xml.tone( :name => 'CED_TONE' ) {
						xml.element( :freq1 => '2100', :freq2 =>   '0', :min => '500', :max =>   '0' )
					}
					xml.tone( :name => 'SIT' ) {
						xml.element( :freq1 =>  '950', :freq2 =>   '0', :min => '256', :max => '400' )
						xml.element( :freq1 => '1400', :freq2 =>   '0', :min => '256', :max => '400' )
						xml.element( :freq1 => '1800', :freq2 =>   '0', :min => '256', :max => '400' )
					}
					xml.tone( :name => 'REORDER_TONE' ) {
						xml.element( :freq1 =>  '400', :freq2 =>   '0', :min => '368', :max => '416' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '336', :max => '368' )
						xml.element( :freq1 =>  '400', :freq2 =>   '0', :min => '256', :max => '288' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '512', :max => '544' )
					}
					xml.tone( :name => 'BUSY_TONE' ) {
						xml.element( :freq1 =>  '400', :freq2 =>   '0', :min => '352', :max => '384' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '352', :max => '384' )
						xml.element( :freq1 =>  '400', :freq2 =>   '0', :min => '352', :max => '384' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '352', :max => '384' )
					}
				}
				
				xml.descriptor( :name  => '49' ) {
					xml.tone( :name => 'CED_TONE' ) {
						xml.element( :freq1 => '2100', :freq2 =>   '0', :min => '500', :max =>   '0' )
					}
					xml.tone( :name => 'SIT' ) {
						xml.element( :freq1 =>  '900', :freq2 =>   '0', :min => '256', :max => '400' )
						xml.element( :freq1 => '1400', :freq2 =>   '0', :min => '256', :max => '400' )
						xml.element( :freq1 => '1800', :freq2 =>   '0', :min => '256', :max => '400' )
					}
					xml.tone( :name => 'REORDER_TONE' ) {
						xml.element( :freq1 =>  '425', :freq2 =>   '0', :min => '224', :max => '272' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '224', :max => '272' )
					}
					xml.tone( :name => 'BUSY_TONE' ) {
						xml.element( :freq1 =>  '425', :freq2 =>   '0', :min => '464', :max => '516' )
						xml.element( :freq1 =>    '0', :freq2 =>   '0', :min => '464', :max => '516' )
					}
				}
			}
		}
		
		xml.configuration( :name => 'fax.conf', :description => 'FAX application configuration' ) {
			xml.settings {
				xml.param( :name => 'use-ecm', :value => 'true' )
				xml.param( :name => 'verbose', :value => 'true' )
				xml.param( :name => 'disable-v17', :value => 'false' )
				xml.param( :name => 'ident', :value => 'Gemeinschaft4 FAX Ident' )
				xml.param( :name => 'header', :value => 'Gemeinschaft4 FAX Header' )
				xml.param( :name => 'spool-dir', :value => '/tmp' )
				xml.param( :name => 'file-prefix', :value => 'fax' )
			}
		}
		
		xml.configuration( :name => 'modules.conf', :description => 'Modules' ) {
			xml.modules {
				xml.tag!( 'load', :module => 'mod_console' )
				xml.tag!( 'load', :module => 'mod_logfile' )
				xml.tag!( 'load', :module => 'mod_xml_rpc' )
				xml.tag!( 'load', :module => 'mod_xml_curl' )
				xml.tag!( 'load', :module => 'mod_cdr_csv' )
				xml.tag!( 'load', :module => 'mod_event_socket' )
				xml.tag!( 'load', :module => 'mod_sofia' )
				xml.tag!( 'load', :module => 'mod_loopback' )
				xml.tag!( 'load', :module => 'mod_commands' )
				xml.tag!( 'load', :module => 'mod_conference' )
				xml.tag!( 'load', :module => 'mod_dptools' )
				xml.tag!( 'load', :module => 'mod_expr' )
				xml.tag!( 'load', :module => 'mod_fifo' )
				xml.tag!( 'load', :module => 'mod_voicemail' )
				xml.tag!( 'load', :module => 'mod_esf' )
				xml.tag!( 'load', :module => 'mod_fsv' )
				xml.tag!( 'load', :module => 'mod_valet_parking' )
				xml.tag!( 'load', :module => 'mod_curl' )
				xml.tag!( 'load', :module => 'mod_dialplan_xml' )
				xml.tag!( 'load', :module => 'mod_sndfile' )
				xml.tag!( 'load', :module => 'mod_native_file' )
				xml.tag!( 'load', :module => 'mod_local_stream' )
				xml.tag!( 'load', :module => 'mod_tone_stream' )
				xml.tag!( 'load', :module => 'mod_spidermonkey' )
				xml.tag!( 'load', :module => 'mod_say_en' )
				xml.tag!( 'load', :module => 'mod_spandsp' )
			}
		}
		
		xml.configuration( :name => 'post_load_modules.conf', :description => 'Modules' ) {
			xml.modules {
			}
		}
		
		
		xml.configuration( :name => 'timezones.conf', :description => 'Timezones' ) {
			xml.timezones {
				@timezones.each_pair { |name, value|
					xml.zone( :name => name, :value => value )
				}
			}
		}
		
		
		xml.configuration( :name => 'voicemail.conf', :description => 'Voicemail' ) {
			xml.settings {
			}
			xml.profiles {
				xml.profile( :name => 'default' ) {
					xml.param( :name => 'file-extension', :value => 'wav' )
					xml.param( :name => 'terminator-key', :value => '#' )
					xml.param( :name => 'max-login-attempts', :value => '3' )
					xml.param( :name => 'digit-timeout', :value => '10000' )
					xml.param( :name => 'min-record-len', :value => '3' )
					xml.param( :name => 'max-record-len', :value => '300' )
					xml.param( :name => 'max-retries', :value => '3' )
					xml.param( :name => 'tone-spec', :value => '%(1000, 0, 640)' )
					xml.param( :name => 'callback-dialplan', :value => 'XML' )
					xml.param( :name => 'callback-context', :value => 'default' )
					xml.param( :name => 'play-new-messages-key', :value => '1' )
					xml.param( :name => 'play-saved-messages-key', :value => '2' )
					xml.param( :name => 'login-keys', :value => '0' )
					xml.param( :name => 'main-menu-key', :value => '0' )
					xml.param( :name => 'config-menu-key', :value => '5' )
					xml.param( :name => 'record-greeting-key', :value => '1' )
					xml.param( :name => 'choose-greeting-key', :value => '2' )
					xml.param( :name => 'change-pass-key', :value => '6' )
					xml.param( :name => 'record-name-key', :value => '3' )
					xml.param( :name => 'record-file-key', :value => '3' )
					xml.param( :name => 'listen-file-key', :value => '1' )
					xml.param( :name => 'save-file-key', :value => '2' )
					xml.param( :name => 'delete-file-key', :value => '7' )
					xml.param( :name => 'undelete-file-key', :value => '8' )
					xml.param( :name => 'email-key', :value => '4' )
					xml.param( :name => 'pause-key', :value => '0' )
					xml.param( :name => 'restart-key', :value => '1' )
					xml.param( :name => 'ff-key', :value => '6' )
					xml.param( :name => 'rew-key', :value => '4' )
					xml.param( :name => 'skip-greet-key', :value => '#' )
					xml.param( :name => 'record-silence-threshold', :value => '200' )
					xml.param( :name => 'record-silence-hits', :value => '2' )
					xml.param( :name => 'web-template-file', :value => 'web-vm.tpl' )
					xml.param( :name => 'operator-extension', :value => 'operator XML default' )
					xml.param( :name => 'operator-key', :value => '9' )
					xml.param( :name => 'vmain-extension', :value => 'vmain XML default' )
					xml.param( :name => 'vmain-key', :value => '*' )
					xml.email {
						xml.param( :name => 'notify-template-file', :value => 'notify-voicemail.tpl' )
						xml.param( :name => 'template-file', :value => 'voicemail.tpl' )
						xml.param( :name => 'date-fmt', :value => '%A, %B %d %Y, %I %M %p' )
						xml.param( :name => 'email-from', :value => '${voicemail_account}@${voicemail_domain}' )
					}
				}
			}
		}
		
		xml.configuration( :name => 'sofia.conf', :description => 'sofia Configuration' ) {
			xml.global_settings {
				xml.param( :name => 'log-level', :value => '0' )
				xml.param( :name => 'debug-presence', :value => '0' )
			}
			xml.profiles {
				xml.profile( :name => 'internal' ) {
					xml.aliases {
					}
					xml.gateways {
					}
					xml.domains {
						xml.domain( :name => 'all', :alias => 'true', :parse => 'false' )
					}
					xml.settings {
						xml.param( :name => 'user-agent-string', :value => 'Gemeinschaft4' )
						xml.param( :name => 'debug', :value => '0' )
						xml.param( :name => 'sip-trace', :value => 'no' )
						xml.param( :name => 'log-auth-failures', :value => 'true' )
						xml.param( :name => 'context', :value => 'internal' )
						xml.param( :name => 'rfc2833-pt', :value => '101' )
						xml.param( :name => 'sip-port', :value => "#{@internal_sip_port}" )
						xml.param( :name => 'dialplan', :value => 'XML' )
						xml.param( :name => 'dtmf-duration', :value => '2000' )
						xml.param( :name => 'inbound-codec-prefs', :value => 'PCMA,PCMU,GSM' )
						xml.param( :name => 'outbound-codec-prefs', :value => 'PCMA,PCMU,GSM' )
						xml.param( :name => 'rtp-timer-name', :value => '' )
						xml.param( :name => 'rtp-ip', :value => "#{@sip_server_ip}" )
						xml.param( :name => 'sip-ip', :value => '127.0.0.1' )
						xml.param( :name => 'hold-music', :value => "#{@hold_music}" )
						xml.param( :name => 'apply-nat-acl', :value => 'nat.auto' )
						xml.param( :name => 'apply-inbound-acl', :value => 'domains' )
						xml.param( :name => 'local-network-acl', :value => 'localnet.auto' )
						xml.param( :name => 'manage-presence', :value => 'true' )
						xml.param( :name => 'inbound-codec-negotiation', :value => 'generous' )
						xml.param( :name => 'tls', :value => 'false' )
						xml.param( :name => 'accept-blind-reg', :value => 'false' )
						xml.param( :name => 'accept-blind-auth', :value => 'false' )
						xml.param( :name => 'nonce-ttl', :value => '60' )
						xml.param( :name => 'disable-transcoding', :value => 'false' )
						xml.param( :name => 'manual-redirect', :value => 'true' )
						xml.param( :name => 'disable-transfer', :value => 'false' )
						xml.param( :name => 'disable-register', :value => 'false' )
						xml.param( :name => 'auth-calls', :value => 'true' )
						xml.param( :name => 'inbound-reg-force-matching-username', :value => 'true' )
						xml.param( :name => 'auth-all-packets', :value => 'false' )
						xml.param( :name => 'ext-rtp-ip', :value => 'auto-nat' )
						xml.param( :name => 'ext-sip-ip', :value => 'auto-nat' )
						xml.param( :name => 'rtp-timeout-sec', :value => '300' )
						xml.param( :name => 'rtp-hold-timeout-sec', :value => '1800' )
						xml.param( :name => 'force-subscription-expires', :value => '120' )
						xml.param( :name => 'challenge-realm', :value => 'auto_from' )
						xml.param( :name => 'inbound-late-negotiation', :value => 'true' )
						xml.param( :name => 'rtp-rewrite-timestamps', :value => 'true' )
					}
				}
				xml.profile( :name => 'external' ) {
					xml.aliases {
					}
					xml.gateways {
					}
					xml.domains {
						xml.domain( :name => 'all', :alias => 'false', :parse => 'true' )
					}
					xml.settings {
						xml.param( :name => 'user-agent-string', :value => 'Gemeinschaft4' )
						xml.param( :name => 'debug', :value => '0' )
						xml.param( :name => 'sip-trace', :value => 'no' )
						xml.param( :name => 'rfc2833-pt', :value => '101' )
						xml.param( :name => 'sip-port', :value => "#{@external_sip_port}" )
						xml.param( :name => 'dialplan', :value => 'XML' )
						xml.param( :name => 'context', :value => 'public' )
						xml.param( :name => 'dtmf-duration', :value => '2000' )
						xml.param( :name => 'inbound-codec-prefs', :value => 'PCMA,PCMU,GSM' )
						xml.param( :name => 'outbound-codec-prefs', :value => 'PCMA,PCMU,GSM' )
						xml.param( :name => 'hold-music', :value => "#{@hold_music}" )
						xml.param( :name => 'rtp-timer-name', :value => 'soft' )
						xml.param( :name => 'local-network-acl', :value => 'localnet.auto' )
						xml.param( :name => 'manage-presence', :value => 'false' )
						xml.param( :name => 'inbound-codec-negotiation', :value => 'generous' )
						xml.param( :name => 'nonce-ttl', :value => '60' )
						xml.param( :name => 'auth-calls', :value => 'false' )
						xml.param( :name => 'rtp-ip', :value => "#{@sip_server_ip}" )
						xml.param( :name => 'sip-ip', :value => '127.0.0.1' )
						xml.param( :name => 'ext-rtp-ip', :value => 'auto-nat' )
						xml.param( :name => 'ext-sip-ip', :value => 'auto-nat' )
						xml.param( :name => 'rtp-timeout-sec', :value => '300' )
						xml.param( :name => 'rtp-hold-timeout-sec', :value => '1800' )
						xml.param( :name => 'tls', :value => 'false' )
					}
				}
			}
		}
	}
	
	
	xml.section( :name => 'dialplan', :description => 'Regex/XML dialplan' ) {
		
		xml.context( :name => 'internal' ) {  #OPTIMIZE This context is called "public" in the original configuration (misc/freeswitch/fs-conf/).
			
			xml.extension( :name => 'from-kamailio' ) {
				xml.condition( :field => 'network_addr', :expression => '^127\.0\.0\.1$' )
				xml.condition( :field => 'destination_number', :expression => '^(.+)$' ) {
					xml.action( :application => 'transfer', :data => '$1 XML default' )
				}
			}
			
		}
		
		xml.context( :name => 'default' ) {
			
			xml.extension( :name => 'unloop' ) {
				xml.condition( :field => '${unroll_loops}', :expression => '^true$' )
				xml.condition( :field => '${sip_looped_call}', :expression => '^true$' ) {
					xml.action( :application => 'deflect', :data => '${destination_number}' )
				}
			}
			
			xml.extension( :name => 'kam-park-in' ) {
				xml.condition( :field => 'destination_number', :expression => '^-park-in-$' ) {
					xml.action( :application => 'valet_park', :data => 'valet_lot auto in 8000 8999' )
				}
			}
			xml.extension( :name => 'kam-park-out' ) {
				xml.condition( :field => 'destination_number', :expression => '^-park-out-$' ) {
					xml.action( :application => 'answer' )
					xml.action( :application => 'valet_park', :data => 'valet_lot ask 4 4 10000 ivr/ivr-enter_ext_pound.wav' )
				}
			}
			xml.extension( :name => 'kam-queue-login' ) {
				xml.condition( :field => 'destination_number', :expression => '^-queue-login-(.*)$' ) {
					xml.action( :application => 'answer' )
					xml.action( :application => 'set', :data => 'result=${fifo_member(add $1 {fifo_member_wait=nowait}sofia/internal/${sip_from_uri}}' )
					xml.action( :application => 'playback', :data => 'ivr/ivr-you_are_now_logged_in.wav' )
				}
			}
			xml.extension( :name => 'kam-queue-logout' ) {
				xml.condition( :field => 'destination_number', :expression => '^-queue-logout-(.*)$' ) {
					xml.action( :application => 'answer' )
					xml.action( :application => 'set', :data => 'result=${fifo_member(del $1 {fifo_member_wait=nowait}sofia/internal/${sip_from_uri}}' )
					xml.action( :application => 'playback', :data => 'ivr/ivr-you_are_now_logged_out.wav' )
				}
			}
			xml.extension( :name => 'kam-queue-in' ) {
				xml.condition( :field => 'destination_number', :expression => '^-kambridge-(-queue-.*)$' ) {
					xml.action( :application => 'playback', :data => 'ivr/ivr-hold_connect_call.wav' )
					xml.action( :application => 'set', :data => 'fifo_music=$${hold_music}' )
					xml.action( :application => 'fifo', :data => '$1 in' )
				}
			}
			xml.extension( :name => 'kam-vbox' ) {
				xml.condition( :field => 'destination_number', :expression => '^-vbox-(.+)$' ) {
					xml.action( :application => 'answer', :data => 'voicemail_authorized=true' )
					xml.action( :application => 'voicemail', :data => 'default ${domain_name} $1' )
				}
			}
			xml.extension( :name => 'kam-vmenu-self' ) {
				xml.condition( :field => 'destination_number', :expression => '^-vmenu-$' ) {
					xml.action( :application => 'log', :data => 'INFO [GS] User ${sip_from_user}@${domain_name} is checking the voicemail ...' )
					xml.action( :application => 'set', :data => 'voicemail_authorized=true' )
					xml.action( :application => 'answer' )
					xml.action( :application => 'voicemail', :data => 'check default ${domain_name} ${sip_from_user}' )
				}
			}
			
			xml.extension(:name => 'kam-fax-receive' ) {
				xml.condition( :field => 'destination_number', :expression => '^-kambridge--fax-receive-$' ) {
					xml.action( :application => 'set', :data => 'proxy_media=true' )
					xml.action( :application => 'set', :data => 'bypass_media=false' )
					xml.action( :application => 'set', :data => 'inherit_codec=true' )
					xml.action( :application => 'set', :data => 'fax_enable_t38_request=true' )
					xml.action( :application => 'set', :data => 'fax_enable_t38=true' )
					xml.action( :application => 'set', :data => "api_hangup_hook=system ${base_dir}/scripts/fax_store.sh FAX-IN-${uuid} ${destination_number} ${caller_id_number}" )
					xml.action( :application => 'rxfax', :data => "#{FAX_FILES_DIRECTORY}/FAX-IN-${uuid}.tif" )
					xml.action( :application => 'hangup' )
				}
			}
			
			xml.extension( :name => 'gs-main' ) {
				xml.condition( :field => '${module_exists(mod_spidermonkey)}', :expression => 'true' )
				xml.condition( :field => 'destination_number', :expression => '^-kambridge-(.+)$' ) {
					xml.action( :application => 'javascript', :data => 'GS.js' )
					xml.action( :application => 'hangup', :data => 'NORMAL_TEMPORARY_FAILURE' )
				}
			}
			
			xml.extension( :name => 'catch-all' ) {
				xml.condition( :field => 'destination_number', :expression => '^(.+)$' ) {
					xml.action( :application => 'bridge', :data => 'sofia/internal/$1@$${domain};fs_path=sip:127.0.0.1:5060' )
				}
			}
			
		}
		
	}
}


# Local Variables:
# mode: ruby
# End:
