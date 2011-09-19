# ruby encoding: utf-8

class FreeswitchCallProcessingController < ApplicationController
(
	skip_authorization_check
	# Allow access from 127.0.0.1 and [::1] only:
	prepend_before_filter { |controller|
		if ! request.local?
			if user_signed_in? && current_user.role == "admin"
				# For debugging purposes.
				logger.info(_bold( "#{logpfx} Request from #{request.remote_addr.inspect} is not local but the user is an admin ..." ))
			else
				logger.info(_bold( "#{logpfx} Denying non-local request from #{request.remote_addr.inspect} ..." ))
				render :status => '403 None of your business',
					:layout => false, :content_type => 'text/plain',
					:text => "<!-- This is none of your business. -->"
				# Maybe allow access in "development" mode?
			end
		end
	}
	
	prepend_before_filter { |controller|
		logger.info( "#{logpfx} ---------------------------------------------" )
	}
	
	
	# http://wiki.freeswitch.org/wiki/Mod_logfile#Log_Levels
	FS_LOG_CONSOLE = 0
	FS_LOG_ALERT   = 1
	FS_LOG_CRIT    = 2
	FS_LOG_ERROR   = 3
	FS_LOG_WARNING = 4
	FS_LOG_NOTICE  = 5
	FS_LOG_INFO    = 6
	FS_LOG_DEBUG   = 7
	
	def action_log( level, message )
	(
		log_level_fs = case level
			when FS_LOG_DEBUG   ; 'DEBUG'
			when FS_LOG_INFO    ; 'INFO'
			when FS_LOG_NOTICE  ; 'NOTICE'
			when FS_LOG_WARNING ; 'WARNING'
			when FS_LOG_ERROR   ; 'ERR'
			when FS_LOG_CRIT    ; 'CRIT'
			when FS_LOG_ALERT   ; 'ALERT'
			when FS_LOG_CONSOLE ; 'CONSOLE'
			else                ; 'CONSOLE'
		end
		# Alternatively we could just use the numeric value for log_level_fs.
		action :log, "#{log_level_fs} ### [GS] #{message}"
	) end
	
	
	def action( app, data = nil )
	(
		@dp_actions ||= []  # the FreeSwitch dialplan actions
		@dp_actions << [ app.to_sym, data ]
	) end
	
	
	# Map FreeSwitch call dispositions to our call forward cases.
	# Values must be :busy, :noanswer or :offline.
	# Comment indicate the SIP status codes that FreeSwitch
	# (sofia_glue_sip_cause_to_freeswitch() in src/mod/endpoints/mod_sofia/sofia_glue.c)
	# maps to the respective Q.Sig cause codes. FreeSwitch doesn't map
	# exactly as specified in RFC 4497. E.g. SIP code 404 "Not found"
	# should be mapped to Q.Sig code 1 "Unallocated number"
	# (UNALLOCATED_NUMBER) but FS maps it to 3 "No route to destination"
	# (NO_ROUTE_DESTINATION). No big problem.
	#
	CALL_FORWARD_DISPOSITIONS_MAP = {
		## 200:
		'NORMAL_CLEARING'          => nil,
		# -:
		'UNALLOCATED_NUMBER'       => :offline,  #OPTIMIZE ?
		# 404, 485, 604:
		'NO_ROUTE_DESTINATION'     => :offline,
		# 486, 600:
		'USER_BUSY'                => :busy,
		# 480:
		'NO_USER_RESPONSE'         => :offline,
		# 400, 481, 500, 503:
		'NORMAL_TEMPORARY_FAILURE' => :offline,
		# -:
		'NO_ANSWER'                => :noanswer,
		# 401, 402, 403, 407, 603:
		'CALL_REJECTED'            => :busy,      # or :offline
		# -:
		'SWITCH_CONGESTION'        => :offline,
		# -:
		'REQUESTED_CHAN_UNAVAIL'   => :offline,
		# 480:
		'NO_USER_RESPONSE'         => :offline,
		# -:
		'SUBSCRIBER_ABSENT'        => :offline,
		# 408, 504:
		'RECOVERY_ON_TIMER_EXPIRE' => :offline,
		# 410:
		'NUMBER_CHANGED'           => :offline,
		# 413, 414, 416, 420, 421, 423, 505, 513:
		'INTERWORKING'             => :offline,
		# 484:
		'INVALID_NUMBER_FORMAT'    => :offline,
		# 488, 606:
		'INCOMPATIBLE_DESTINATION' => :offline,
		# 502:
		'NETWORK_OUT_OF_ORDER'     => :offline,
		# 405:
		'SERVICE_UNAVAILABLE'      => :offline,
		# 406, 415, 501:
		'SERVICE_NOT_IMPLEMENTED'  => :offline,
		# 482, 483:
		'EXCHANGE_ROUTING_ERROR'   => :offline,
		# 487:
		'ORIGINATOR_CANCEL'        => :offline,
		# everything else:
		'NORMAL_UNSPECIFIED'       => :offine,
	}
	CALL_FORWARD_DISPOSITIONS_MAP.default = :offline
	
	
	protected
	
	
	def call_log( sip_acct_id=nil, type=nil, disp=nil, uuid=nil, src_num=nil, src_name=nil, dst_num=nil, dst_name=nil, fwdd_to=nil )
	(
		CallLog.create({
			:sip_account_id    => sip_acct_id,
			:call_type         => type,
			:uuid              => uuid,
			:disposition       => disp,
			:source            => src_num,
			:source_name       => src_name,
			:destination       => dst_num,
			:destination_name  => dst_name,
			:forwarded_to      => fwdd_to,
		})
	) end
	
	
	def logpfx
	(
		return "[CallProc]" << (@call_id ? " (" << @call_id.to_s[0,50] << ")" : '')
	) end
	
	
	# Process the request from FreeSwitch (GS.js).
	# Called from actions().
	#
	# For FreeSwitch dialplan applications see
	# http://wiki.freeswitch.org/wiki/Mod_dptools
	# http://wiki.freeswitch.org/wiki/Category:Dptools
	#
	def process_request()
	(
		############################################################
		# Get the request parameters we need (source):
		############################################################
		
	#	arg_src_sip_user          = _arg :'Caller-Username'
		arg_src_sip_user          = _arg :'var_sip_from_user'  # / var_sip_from_user_stripped ?
		
		arg_src_cid_sip_domain    = _arg :'var_sip_from_host'
		arg_src_cid_sip_user      = _arg :'Caller-Caller-ID-Number'
		arg_src_cid_sip_display   = _arg :'Caller-Caller-ID-Name'  # now always included
		arg_src_cid_sip_display   = _arg :'var_sip_from_display' if arg_src_cid_sip_display.blank?
		
		
		############################################################
		# Get the request parameters we need (destination):
		############################################################
		
		arg_dst_sip_user_alias    = _arg :'Caller-Destination-Number'  # / var_sip_req_user
		# Strip "-kambridge-" prefix added in kamailio.cfg:
		arg_dst_sip_user_alias    = arg_dst_sip_user_alias.to_s.gsub( /^-kambridge-/, '' )
		# Un-alias the SIP username. (Alias lookup has already been done in kamailio.cfg.):
		arg_dst_sip_user_real     = arg_dst_sip_user_alias
	#	arg_dst_sip_domain        = _arg :'var_sip_req_host'
		arg_dst_sip_domain        = _arg :'var_sip_to_host'
		# This is the number as dialed by the caller (before unaliasing in Kamailio):
		arg_dst_sip_dnis_user     = _arg :'var_sip_to_user'
		
		
		############################################################
		# Get the request parameters we need (misc):
		############################################################
		
		arg_sip_call_id           = _arg :'var_sip_call_id'
		arg_call_disposition      = _arg :'var_originate_disposition'
		arg_call_uuid             = _arg :'var_uuid'
		
		@call_id = arg_sip_call_id
		
		
		############################################################
		# Initialize objects:
		############################################################
		
		src_sip_account = nil   # the src. SipAccount (if any)
		src_user        = nil   # the src. User (if any)
		
	#	dst_type        = nil   # the dst. type
		dst_sip_account = nil   # the dst. SipAccount (if any)
		dst_conference  = nil   # the dst. Conference (if any)
		dst_queue       = nil   # the dst. Queue (if any)
		
		src_call_log    = nil   # the src. CallLog (if any)
		dst_call_log    = nil   # the dst. CallLog (if any)
		
		if ! arg_src_sip_user.blank?
			src_sip_account = (
				SipAccount.where({ :auth_name => arg_src_sip_user })
				.joins( :sip_server )
				.where( :sip_servers => { :host => arg_src_cid_sip_domain })
				.first
			)
			src_call_log = CallLog.where({ :uuid => arg_call_uuid, :sip_account_id => src_sip_account.id }).first if src_sip_account
		end
		
		if ! arg_dst_sip_user_real.blank?
			if arg_dst_sip_user_real.match( /^-conference-.*/ )
				#dst_type = :conference
				dst_conference = (
					Conference.where({ :uuid => arg_dst_sip_user_real })
					.first
				)
			else
				#dst_type = :sip_account
				dst_sip_account = (
					SipAccount.where({ :auth_name => arg_dst_sip_user_real })
					.joins( :sip_server )
					.where( :sip_servers => { :host => arg_dst_sip_domain })
					.first
				)
				dst_call_log = CallLog.where({ :uuid => arg_call_uuid, :sip_account_id => dst_sip_account.id }).first if dst_sip_account
			end
		end
		
		
		############################################################
		# Log the request:
		############################################################
		
		#logger.info(_bold( "#{logpfx} SIP Call-ID: #{arg_sip_call_id}, UUID: #{arg_call_uuid}" ))
		logger.info(_bold( "#{logpfx} Call" \
			<< " from #{ quote_sip_displayname( arg_src_cid_sip_display )}" \
			<< " <#{ enc_sip_user( arg_src_cid_sip_user )}@#{ arg_src_cid_sip_domain }>" \
			<< " to" \
			<< " alias <#{ enc_sip_user( arg_dst_sip_user_alias )}@#{ arg_dst_sip_domain }>" \
			<< " (dialed <#{ enc_sip_user( arg_dst_sip_dnis_user )}>)" \
			<< " ..."
		))
		logger.info(_bold( "#{logpfx} Caller: <#{ enc_sip_user( arg_src_sip_user      )}@#{ arg_src_cid_sip_domain }> (" << (src_sip_account ? "SipAccount ID #{src_sip_account.id}" : "no SipAccount") << ")" ))
		logger.info(_bold( "#{logpfx} Callee: <#{ enc_sip_user( arg_dst_sip_user_real )}@#{ arg_dst_sip_domain     }> (" << (dst_sip_account ? "SipAccount ID #{dst_sip_account.id}" : "no SipAccount") << ")" ))
		
		if false  # you may want to enable this during debugging
			_args.each { |k,v|
				case v
					when String
						logger.debug( "   #{k.ljust(36)} = #{v.inspect}" )
					#when Hash  # not used (yet?)
					#	v.each { |k1,v1|
					#		logger.debug( "   #{k}[ #{k1.ljust(30)} ] = #{v1.inspect}" )
					#	}
				end
			}
		end
		
		
		############################################################
		# Iteration counter:
		############################################################
		
		arg_continue_counter      = _arg :'var_x_continue_counter'
		arg_continue_counter      = 0 if arg_continue_counter.blank?
		arg_continue_counter      = arg_continue_counter.to_i + 1
		
		action :set, "x_continue_counter=#{arg_continue_counter}"
		
		logger.info(_bold( "#{logpfx} Iteration count: #{arg_continue_counter}" ))
		if arg_continue_counter >= 20
			# Protection against code below, should there accidentally be a
			# code path that calls "action :_continue" without calling
			# "action :bridge" first or any other stateful information that
			# it evaluates.
			logger.info(_bold( "#{logpfx} Too many iterations (#{arg_continue_counter})." ))
			action_log( FS_LOG_WARNING, "Too many iterations (#{arg_continue_counter})." )
			case _arg( 'Answer-State' )
				when 'ringing' ; action :respond, '500 Server internal error'
				else           ; action :hangup
			end
			return
		end
		
		
		# For FreeSwitch dialplan applications see
		# http://wiki.freeswitch.org/wiki/Mod_dptools
		# http://wiki.freeswitch.org/wiki/Category:Dptools
		
		# Note: If you want to do multiple iterations (requests) you
		# have to set channel variables to keep track of "where you
		# are" i.e. what you have done already.
		# And you have to explicitly send "_continue" as the last
		# application.
		
		# Here's an example: {
		#action :set       , 'effective_caller_id_number=1234567'
		#action :bridge    , "sofia/internal/#{arg_dst_sip_user_real}"
		#action :answer
		#action :sleep     , 1000
		#action :playback  , 'tone_stream://%(500, 0, 640)'
		#action :set       , 'voicemail_authorized=${sip_authorized}'
		#action :voicemail , "default $${domain} #{arg_dst_sip_user_real}"
		#action :hangup
		#action :_continue
		# end of example }
		
		
		############################################################
		# Load the caller's variables:
		############################################################
		
		if src_sip_account
			# Pull the channel variables defined for a user as if the user had authenticated.
			# http://wiki.freeswitch.org/wiki/Misc._Dialplan_Tools_set_user
			action :set_user, "#{ enc_sip_user( arg_src_sip_user )}@#{ arg_src_cid_sip_domain }"
		end
		
		
		############################################################
		# Check if the request has a destination ("extension"):
		############################################################
		
		if arg_dst_sip_user_alias.blank?
			logger.info(_bold( "#{logpfx} No destination given." ))
			case _arg( 'Answer-State' )
				when 'ringing' ; action :respond, '404 Not found'  # or '400 Bad Request'? or '484 Address Incomplete'?
				else           ; action :hangup
			end
			return
		end
		
		
		############################################################
		# Figure out what to do with the call:
		############################################################
		
		if arg_call_disposition.blank?; (
			# We didn't try to call the SIP account yet.
			#logger.info( "#{logpfx} We didn't try to call the SIP account yet." )
			
			#set_caller_id( src_sip_account, arg_src_cid_sip_display, arg_src_sip_user, arg_dst_sip_domain )
			
			# Write call log:
			if src_sip_account
				call_log(
					src_sip_account.id, 'out', 'answered', arg_call_uuid,
					arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, nil
				)
			end
			
			
			############################################################
			# Check unconditional call forward ("always"):
			############################################################
			
			cfwd_always    = find_call_forward( dst_sip_account, :always    , arg_src_cid_sip_user )
			if cfwd_always; (
				# We have an unconditional call-forward.
				logger.info(_bold( "#{logpfx} Found call-forward on #{cfwd_always.reason_str.inspect} for caller #{cfwd_always.source.inspect} to #{cfwd_always.destination.inspect}." ))
				
				if cfwd_always.destination.blank?  # Blacklisted.
					logger.info(_bold( "#{logpfx} Blacklisted." ))
					
					action :respond, "480 Temporarily unavailable"
					return  # no call log
					
				else  # Real call forward with destination.
					logger.info(_bold( "#{logpfx} Forwarding to #{cfwd_always.destination.inspect} ..." ))
					
					check_valid_voicemail_box_destination( cfwd_always.destination )
					
					call_log(
						dst_sip_account.id, 'in', 'forwarded', arg_call_uuid,
						arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, cfwd_always.destination
					)
					
					action :transfer, "#{enc_sip_user( cfwd_always.destination )} XML default"
				end
			)
			else (
				# No unconditional call-forward.
				
				set_caller_id( src_sip_account, arg_src_cid_sip_display, arg_src_sip_user, arg_dst_sip_domain )
				
				
				############################################################
				# Check assistant call forward ("assistant"):
				############################################################
				
				cfwd_assistant = find_call_forward( dst_sip_account, :assistant , arg_src_cid_sip_user )
				
				#OPTIMIZE Clear up / explain this is_assistant code. It's hard to understand. Who's the assistant, the src or the dst?
				is_assistant = false
				if (cfwd_reason_assistant = CallForwardReason.where(:value => "assistant").first)
					if (assistant_sip_account = SipAccount.where(:auth_name => "#{arg_dst_sip_user_real}").first)
						is_assistant = ! CallForward.where({
							:call_forward_reason_id => cfwd_reason_assistant.id,
							:sip_account_id => assistant_sip_account.id,
							:destination => "#{arg_src_cid_sip_user}",
							:active => true,
						}).first.nil?
					end
				end
				
				if cfwd_assistant; (
					logger.info(_bold( "#{logpfx} Found call-forward on #{cfwd_assistant.reason_str.inspect} for caller #{cfwd_assistant.source.inspect} to #{cfwd_assistant.destination.inspect}." ))
					
					if is_assistant; (  # Is the assistant of a call forward.(?)
						logger.info(_bold( "#{logpfx} Is the assistant." ))
						
						call_log(
							dst_sip_account.id, 'in', 'answered', arg_call_uuid,
							arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, nil
						)
						
						action_set_ringback()
						action :bridge, "sofia/internal/#{enc_sip_user( arg_dst_sip_user_real )}@#{arg_dst_sip_domain};fs_path=sip:127.0.0.1:5060"
						after_bridge_actions()
						return
						
					)
					else (  # Has a call forward to an assistant.(?)
						logger.info(_bold( "#{logpfx} Has a call forward to an assistant." ))
						
						call_log(
							dst_sip_account.id, 'in', 'answered', arg_call_uuid,
							arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, nil
						)
						
						assistant_extension  = Extension.where( :extension => "#{cfwd_assistant.destination}", :active => true ).first
						if assistant_extension; (
							assistant_sip_account = assistant_extension.sip_accounts.first
							call_log(
								assistant_sip_account.id, 'in', 'answered', arg_call_uuid,
								arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, nil
							)
							
							action :export, "alert_info=http://example.com;info=#{arg_dst_sip_user_real};x-line-id=0"
							# Note: "localhost" in the Alert-Info header does not work for Snom phones.
							action_set_ringback()
							action :bridge, "sofia/internal/#{enc_sip_user( arg_dst_sip_user_real )}@#{arg_dst_sip_domain};fs_path=sip:127.0.0.1:5060,sofia/internal/#{enc_sip_user( assistant_extension.destination )}@#{arg_dst_sip_domain};fs_path=sip:127.0.0.1:5060"
						)
						else (
							# Assistant extension not found. Wrongly configured call forward.
							logger.info(_bold( "#{logpfx} Assistant extension for #{cfwd_assistant.destination.inspect} not found." ))
							action_set_ringback()
							action :bridge, "sofia/internal/#{enc_sip_user( arg_dst_sip_user_real )}@#{arg_dst_sip_domain};fs_path=sip:127.0.0.1:5060"
						) end
						after_bridge_actions()
						
						return
					) end
				)
				else (
					############################################################
					# Call the destination.
					############################################################
					
					#set_caller_id( src_sip_account, arg_src_cid_sip_display, arg_src_sip_user, arg_dst_sip_domain )
					
					# Get timeout from call-forward on timeout ("noanswer"):
					#
					cfwd = find_call_forward( dst_sip_account, :noanswer, arg_src_cid_sip_user )
					timeout = cfwd ? cfwd.call_timeout.to_i : 30
					if timeout < 1; timeout = 1; end
					
					#case dst_type ...  # Checking the type that it should be is not the same as actually checking in the database!
					if dst_sip_account; (
						logger.info(_bold( "#{logpfx} Destination is SIP account <#{ enc_sip_user( arg_dst_sip_user_real ) }@#{ arg_dst_sip_domain }>." ))
						
						#OPTIMIZE It's strange to write call logs as "answered" and then
						# delete them later if the call wasn't answered.
						call_log(
							dst_sip_account.id, 'in', 'answered', arg_call_uuid,
							arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, nil
						)
						
						# Ring the SIP account via Kamailio:
						action_log( FS_LOG_INFO, "Calling SIP account <#{ enc_sip_user( arg_dst_sip_user_real ) }@#{ arg_dst_sip_domain }> ..." )
						action :set       , "call_timeout=#{timeout}"
						action :export    , "sip_contact_user=ufs"
						action_set_ringback()
						action :bridge    , "sofia/internal/#{enc_sip_user( arg_dst_sip_user_real )}@#{arg_dst_sip_domain};fs_path=sip:127.0.0.1:5060"
						after_bridge_actions()
						action :_continue
					)
					elsif dst_conference; (
						logger.info(_bold( "#{logpfx} Entering conference room <#{ enc_sip_user( arg_dst_sip_user_real ) }@#{ arg_dst_sip_domain }> ..." ))
						action_log( FS_LOG_INFO, "Entering conference room <#{ enc_sip_user( arg_dst_sip_user_real ) }@#{ arg_dst_sip_domain }> ..." )
						action :conference, "#{enc_sip_user( dst_conference.uuid )}@default+#{enc_sip_user( dst_conference.pin )}"
					)
					else (
						logger.info(_bold( "#{logpfx} Extension <#{ enc_sip_user( arg_dst_sip_user_real ) }> not found. Calling outbound ..." ))
						action :export    , "sip_contact_user=ufs"
						
						# Get applicable outbound routes, i.e. the ones that are
						# independent of a user and the ones that apply to the
						# user (if any) of the current SIP account (src_sip_account).
						
						src_user = src_sip_account.user if src_sip_account
						
						if src_user
							logger.debug( "#{logpfx} Fetching routes that apply to any account or user #{src_user.username.inspect}  ..." )
							routes = DialplanRoute.where(
								DialplanRoute.arel_table[:user_id].eq( nil ) .or \
								DialplanRoute.arel_table[:user_id].eq( src_user.id   )
							).order( DialplanRoute.arel_table[:position] )
						else
							logger.debug( "#{logpfx} Fetching routes that apply to any account  ..." )
							routes = DialplanRoute.where(
								DialplanRoute.arel_table[:user_id].eq( nil )
							).order( DialplanRoute.arel_table[:position] )
						end
						logger.debug( "#{logpfx} Got #{routes.length} route(s) that might apply." )
						logger.debug( "#{logpfx} Destination: #{arg_dst_sip_user_real.inspect}" )
						routes.each { |route|
							begin
								match_result = route.match( arg_dst_sip_user_real.to_s, src_user.try(:id) ) || {}
							rescue => e
								match_result = {}
								logger.error(_bold( "#{logpfx} Error: #{e.message} (#{e.class.name})" ))
							end
							logger.debug( "#{logpfx} Route #{route.eac}|#{route.dialplan_pattern.try(:pattern)} (#{route.name.inspect}) => Match: #{match_result[:match].inspect}" + (match_result[:match] ? '' : ", reason: #{match_result[:reason].to_s.inspect}") )
							if match_result[:match]
								if ! route.sip_gateway
									logger.info(_bold( "#{logpfx} Route says: forbidden." ))
									action :respond, "403 Forbidden"
									action :hangup
									return
								end
								
								phone_number = (match_result[:opts] || {})[:number].to_s
								sip_gateway_name = "gateway-#{sip_gateway.try(:id)}"
								logger.info(_bold( "#{logpfx} Calling #{phone_number.inspect} via gateway #{sip_gateway.try(:hostport).inspect} (#{sip_gateway_name}) ..." ))
								
								action_set_ringback()
								action :bridge,
									#"{sip_network_destination=sip:#{enc_sip_user( arg_dst_sip_user_real )}@127.0.0.1:5060}" <<
									"{sip_route_uri=sip:127.0.0.1:5060}" <<
									"{sip_invite_req_uri=sip:#{enc_sip_user( arg_dst_sip_user_real )}@#{ sip_gateway.hostport }}" <<  # Request-URI
									"{sip_invite_to_uri=<sip:#{enc_sip_user( arg_dst_sip_user_real )}@#{ sip_gateway.hostport }>}" <<  # To-URI
									"sofia/gateway/#{sip_gateway_name}/" <<
									"#{enc_sip_user( arg_dst_sip_user_real )}" <<
									";fs_path=sip:127.0.0.1:5060"
								
								after_bridge_actions()
								#action :hangup
								return
							end
						}
						logger.info(_bold( "#{logpfx} No matching route found." ))
						action :respond, "403 Forbidden"
						action :hangup
						return
						
					) end
					
				) end
			) end
		)
		else (
			############################################################
			# We have already tried to call the SIP account.
			############################################################
			# We will now check call-forwards on busy ("busy") / unavailable
			# ("noanswer") / offline ("offline").
			
			cfwd_mapped_reason = CALL_FORWARD_DISPOSITIONS_MAP[ arg_call_disposition ]
			logger.info(_bold( "#{logpfx} Call disposition: #{arg_call_disposition.inspect} => #{cfwd_mapped_reason.inspect}" ))
			
			if ! cfwd_mapped_reason
				logger.info(_bold( "#{logpfx} Disposition does not map to any call forward case." ))
				action :hangup
				return
			end
			
			
			############################################################
			# Check if there is a call forward for the case:
			############################################################
			
			cfwd = find_call_forward( dst_sip_account, cfwd_mapped_reason, arg_src_cid_sip_user )
			
			if cfwd; (  # Call forward.
				logger.info(_bold( "#{logpfx} Found call-forward on #{cfwd.reason_str.inspect} for caller #{cfwd.source.inspect} to #{cfwd.destination.inspect}." ))
				
				if cfwd.destination.blank?  # Blacklisted.
					logger.info(_bold( "#{logpfx} Blacklisted." ))
					
					action :respond, "480 Temporarily unavailable"
					return  # no call log
				
				else  # Real call forward with destination.
					logger.info(_bold( "#{logpfx} Forwarding to #{cfwd.destination.inspect} ..." ))
					
					check_valid_voicemail_box_destination( cfwd.destination )
					
					call_log_disposition = 'forwarded'
					call_log_forwarded_to = cfwd.destination
					
					action :transfer, "#{enc_sip_user( cfwd.destination )} XML default"
				end
			)
			else (  # No call forward.
				logger.info(_bold( "#{logpfx} No matching call-forward." ))
				
				call_log_disposition = 'noanswer'
				call_log_forwarded_to = nil
				
				action :hangup
			) end
			
			# Write the call log:
			dst_call_log.destroy if dst_call_log
			if dst_sip_account
				call_log(
					dst_sip_account.id, 'in', call_log_disposition, arg_call_uuid,
					arg_src_cid_sip_user, arg_src_cid_sip_display, arg_dst_sip_dnis_user, nil, nil
				)
			end
			
		) end
	) end
	
	
	
	def set_caller_id( src_sip_account, arg_src_cid_sip_display, arg_src_sip_user, arg_dst_sip_domain )
	(
		# Note: P-Asserted-Identity is set in the SIP proxy (Kamailio).
		
		action :set, "sip_cid_type=none"  # do not send P-Asserted-Identity
		
		clir = false  #OPTIMIZE Read from SIP account.
		if ! clir
			if src_sip_account
				cid_display = src_sip_account.caller_name
				extensions  = src_sip_account.extensions.where( :active => true )
				preferred_extension = extensions.first  #OPTIMIZE Depends on the gateway.
				cid_user    = preferred_extension ? preferred_extension.extension.to_s : 'anonymous'
			else
				cid_display = "[?] " << arg_src_cid_sip_display.to_s
				cid_user    = arg_src_sip_user.to_s
			end
			cid_host    = arg_dst_sip_domain.to_s  #OPTIMIZE
		else
			cid_display = "Anonymous"  # RFC 2543, RFC 3325
			cid_user    = 'anonymous'  # RFC 2543, RFC 3325
			cid_host    = "anonymous.invalid"  # or "127.0.0.1"
		end
		
		## RFC 2543:
		action :set, "effective_caller_id_number=#{ enc_sip_user( cid_user )}"
		action :set, "effective_caller_id_name=#{ enc_sip_displayname( cid_display )}"
		## RFC 3325:
		action :set, "sip_h_P-Preferred-Identity=#{ quote_sip_displayname( cid_display )} <sip:#{ enc_sip_user( cid_user )}@#{ cid_host }>"
		# RFC 3325, RFC 3323:
		action :set, "sip_h_Privacy=" << ((! clir) ? 'none' : 'id;header')
	) end
	
	
	def after_bridge_actions()
	(
		#action_log( FS_LOG_INFO, 'B-leg hangup cause: ${bridge_hangup_cause}' )
		#action_log( FS_LOG_INFO, 'A-leg hangup cause: ${hangup_cause}' )
		#action_log( FS_LOG_INFO, 'A-leg hangup Q.850 cause: ${hangup_cause_q850}' )
	) end
	
	def action_set_ringback()
		action :set, 'ringback=$${de-ring}'
		action :set, 'transfer_ringback=$${de-ring}'
	end
	
	public
	
	# GET  /freeswitch-call-processing/actions.xml
	# POST /freeswitch-call-processing/actions.xml
	def actions()
	(
		process_request()
		logger.info( "#{logpfx} ----------" )
		
		respond_to { |format|
			format.xml {
				default_subfmt = :common
				params[:subfmt] = default_subfmt if params[:subfmt].blank?
				params[:subfmt] = params[:subfmt].to_sym
				#params[:subfmt] = default_subfmt if ! [ :e4x, :common ].include?( params[:subfmt] )
				
				case params[:subfmt]
					when :e4x   ; render :'actions.e4x'    , :layout => false
					else        ; render :'actions.common' , :layout => false
				end
			}
			format.all {
				render :status => '406 Not Acceptable',
					:layout => false, :content_type => 'text/plain',
					:text => "<!-- Only XML format is supported. -->"
			}
		}
		return
	) end
	
	
	# Returns the request parameter from the content (for POST) or
	# the query parameter from the URL (for GET) or nil.
	# This is needed because Rails doesn't pass a request argument
	# named 'action' to the params array as it overrides the
	# "action" arg.!
	# 
	def _arg( name )
	(
		name = name.to_sym
		return request.request_parameters[name] || request.query_parameters[name]
	) end
	
	def _args()
	(
		return (request.request_parameters.length > 0) \
			? request.request_parameters \
			: request.query_parameters
	) end
	
	
	def _bold( str )
	(
		return "\e[0;32;1m#{str} \e[0m "
	) end
	
	
	# Encode special characters in a SIP username.
	# See the "user" rule in http://tools.ietf.org/html/rfc3261 .
	#
	def enc_sip_user( str )  #OPTIMIZE
	(
		str = str.to_s
		
		# Sanitize control characters. They could be encoded but cause
		# problems for many implementations:
		str = str.gsub( /[\x00-\x1F]+/, ' ' )
		
		# FreeSwitch doesn't handle " " even in its encoded form:
		str = str.gsub( / +/, '' )
		
		#unsafe = /[^a-zA-Z0-9\-_.!~*'()&=+$,;?\/]/
		unsafe = /[^a-zA-Z0-9\-_.!~*'()&=+$,;?]/  # without "/" (which are special for FreeSwitch)
		return pct_enc_re( str, unsafe )
	) end
	
	
	#OPTIMIZE We may want to add a sip_tel_subscriber_encode() method
	# which refers to the "telephone-subscriber" rule from
	# http://tools.ietf.org/html/rfc3261 .
	
	# Encode special characters in a SIP display-name.
	# See the "display-name"/"qdtext"/"quoted-pair" rules in
	# http://tools.ietf.org/html/rfc3261 .
	#
	def enc_sip_displayname( str )
	(
		#orig_str = str
		str = str.to_s.force_encoding( Encoding::ASCII_8BIT )
		
		# Sanitize control characters. They could be encoded but cause
		# problems for many implementations:
		str = str.gsub( /[\x00-\x1F]+/, ' ' )
		
		# FreeSwitch doesn't handle "<", ">" even in its encoded forms:
		str = str.gsub( /[<>]+/, ' ' )
		
		# without "/", ":", "<", ">" (which are special for FreeSwitch)
		safe = /(?:
			  [ !\#\$\%&'()*+,\-.0-9;=?@A-Z\[\]^_`a-z{|}~]
			| [\xC0-\xDF][\x80-\xBF]{1}
			| [\xE0-\xEF][\x80-\xBF]{2}
			| [\xF0-\xF7][\x80-\xBF]{3}
			| [\xF8-\xFB][\x80-\xBF]{4}
			| [\xFC-\xFD][\x80-\xBF]{5}
		)+/xn
		ret = []
		str = str.to_s << 'a'  # add a safe char at the end so we get a match
		pos = 0
		while ((safe_part = safe.match( str, pos )) != nil)
			# add the unsafe part before the current match:
			#ret << "-" + "{" + str[ pos, safe_part.begin(0)-pos ] + "}"
			ret << pct_enc_re( str[ pos, safe_part.begin(0)-pos ], /./ )
			
			# add the safe part:
			ret << safe_part.to_s
			
			pos = safe_part.end(0)
		end
		ret = ret.join('')
		ret = ret[ 0, ret.bytesize-1 ].force_encoding( Encoding::UTF_8 )
		#logger.debug( "enc_sip_displayname( #{orig_str.inspect} )  =>  #{ret.inspect}" )
		return ret
	) end
	
	
	# Like enc_sip_displayname() but enclosed in double quotes.
	# Returns an empty string (no quotes) for .blank?() strings
	#
	def quote_sip_displayname( str )
	(
		return '' if str.blank?
		return '"' << enc_sip_displayname( str ).to_s << '"'
	) end
	
	
	def pct_enc_re( str, re_unsafe )
	(
		return str.to_s.gsub( re_unsafe ) {
			unsafe_char = $&
			esc = ''
			unsafe_char.each_byte { |ub|
				esc << sprintf('%%%02X', ub)  # must be uppercase!
			}
			esc
		}.force_encoding( Encoding::US_ASCII )
	) end
	
	
	# Finds a call forwarding rule of a SIP account by reason and source.
	#
	def find_call_forward( sip_account, reason, source )
	(
		return CallForward.find_matching( sip_account, reason, source )
	) end
	
	
	def check_valid_voicemail_box_destination( destination )
	(
		if destination.to_s.match( /^-vbox-/ )
			vbox_sip_user = destination.to_s.gsub( /^-vbox-/, '' )  # this is a SIP account's auth_name
			#OPTIMIZE Where's the destination's domain?
			
			#TODO Check that the SIP account referenced by "-vbox-..." actually
			# has a voicemail_server etc.
			
			#if dst_sip_account
			#	if ! dst_sip_account.voicemail_server
			#		action_log( FS_LOG_INFO, "SIP account #{arg_dst_sip_user_real} doesn't have a voicemail server." )
			#	else
			#		if ! dst_sip_account.voicemail_server.is_local
			#			action_log( FS_LOG_INFO, "Voicemail server of SIP account #{arg_dst_sip_user_real} isn't local." )
			#			action :respond, "480 No voicemail here"  #OPTIMIZE
			#		else
			#			#if dst_sip_account.voicemail_server.host != arg_dst_sip_domain
			#			#	action_log( FS_LOG_INFO, "Voicemail server of SIP account #{arg_dst_sip_user_real} is local but #{dst_sip_account.voicemail_server.host.inspect} != #{arg_dst_sip_domain.inspect}." )
			#			#	action :respond, "480 No voicemail here"  #OPTIMIZE
			#			#else
			#				action_log( FS_LOG_INFO, "Going to voicemail for #{arg_dst_sip_user_real}@#{arg_dst_sip_domain} ..." )
			#				action :answer
			#				action :sleep, 250
			#				action :set, "voicemail_alternate_greet_id=#{ enc_sip_user( arg_dst_sip_dnis_user )}"
			#				action :voicemail, "default #{arg_dst_sip_domain} #{enc_sip_user( arg_dst_sip_user_real )}"
			#			#end
			#		end
			#	end
			#end
			
		end
	) end
	
	
) end
