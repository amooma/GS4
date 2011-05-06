class FreeswitchCallProcessingController < ApplicationController
(
	# Allow access from 127.0.0.1 and [::1] only.
	prepend_before_filter { |controller|
		if ! request.local?
			if user_signed_in?  #OPTIMIZE && is admin
				# For debugging purposes.
				logger.info(_bold( "[FS] Request from #{request.remote_addr.inspect} is not local but the user is an admin ..." ))
			else
				logger.info(_bold( "[FS] Denying non-local request from #{request.remote_addr.inspect} ..." ))
				render :status => '403 None of your business',
					:layout => false, :content_type => 'text/plain',
					:text => "<!-- This is none of your business. -->"
				# Maybe allow access in "development" mode?
			end
		end
	}
	#before_filter :authenticate_user!
	#OPTIMIZE Implement SSL with client certificates.
	
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
		action :log, "#{log_level_fs} ### [GS] #{message}"
	end
	
	def action( app, data = nil )
		@dp_actions = [] if ! @dp_actions  # the FreeSwitch dialplan actions
		@dp_actions << [ app, data ]
	end
	
	# GET  /freeswitch-call-processing/actions.xml
	# POST /freeswitch-call-processing/actions.xml
	def actions()
	(
		call_src_sip_username     = _arg( 'Caller-Username' )
		call_src_cid_userinfo     = _arg( 'Caller-Caller-ID-Number' )
		call_src_cid_displayname  = _arg( 'Caller-Caller-ID-Name' )
		call_dst_sip_userinfo     = _arg( 'Caller-Destination-Number' )
		call_dst_sip_domain       = _arg( 'var_sip_to_host' )
		
		# Strip "-kambridge-" prefix added in kamailio.cfg:
		call_dst_sip_userinfo = call_dst_sip_userinfo.gsub( /^-kambridge-/, '' )
		
		logger.info(_bold( "[FS] Call-proc. request, acct. #{call_src_sip_username.inspect} as #{call_src_cid_userinfo.inspect} (#{call_src_cid_displayname.inspect}) -> #{call_dst_sip_userinfo.inspect} ..." ))
		_args.each { |k,v|
			case v
				when String
					#logger.debug( "   #{k.ljust(36)} = #{v.inspect}" )
				#when Hash
				#	v.each { |k1,v1|
				#		logger.debug( "   #{k}[ #{k1.ljust(30)} ] = #{v1.inspect}" )
				#	}
			end
		}
		
		# For FreeSwitch dialplan applications see
		# http://wiki.freeswitch.org/wiki/Mod_dptools
		# http://wiki.freeswitch.org/wiki/Category:Dptools
		
		# Note: If you want to do multiple iterations (requests) you
		# have to set channel variables to keep track of "where you
		# are" i.e. what you have done already.
		# And you have to explicitly send "_continue" as the last
		# application.
				
		if call_dst_sip_userinfo.blank?
			case _arg( 'Answer-State' )
				when 'ringing'
					action :respond   , '404 Not Found'  # or '400 Bad Request'? or '484 Address Incomplete'?
				else
					action :hangup    , ''
			end
		else
			
			call_dst_real_sip_username = call_dst_sip_userinfo  # un-alias
			# (Alias lookup has already been done in kamailio.cfg.)
			
			# Here's an example: {
			#action :set       , 'effective_caller_id_number=1234567'
			#action :bridge    , "sofia/internal/#{call_dst_real_sip_username}"
			#action :answer
			#action :sleep     , 1000
			#action :playback  , 'tone_stream://%(500, 0, 640)'
			#action :set       , 'voicemail_authorized=${sip_authorized}'
			#action :voicemail , "default $${domain} #{call_dst_real_sip_username}"
			#action :hangup
			#action :_continue
			# end of example }
			
			
			# http://kb.asipto.com/freeswitch:kamailio-3.1.x-freeswitch-1.0.6d-sbc#dialplan
			
			#OPTIMIZE Implement call-forwardings here ...
			
			# Ring the SIP user via Kamailio for 30 seconds:
			action_log( FS_LOG_INFO, "Calling #{call_dst_real_sip_username} ..." )
			action :set       , "call_timeout=5"
			action :export    , "sip_contact_user=ufs"
			action :bridge    , "sofia/internal/#{call_dst_real_sip_username}@#{call_dst_sip_domain};fs_path=sip:127.0.0.1:5060"
			
			#OPTIMIZE Implement call-forward on busy/unavailable here ...
			
			# Go to voicemail:
			action_log( FS_LOG_INFO, "Going to voicemail ..." )
			action :answer
			action :voicemail , "default #{call_dst_sip_domain} #{call_dst_real_sip_username}"
			action :hangup
			
			
		end
		
		
		respond_to { |format|
			format.xml {
				render :actions, :layout => false
			}
			format.all {
				render :status => '406 Not Acceptable',
					:layout => false, :content_type => 'text/plain',
					:text => "<!-- Only XML format is supported. -->"
			}
		}
		return
	)end
	
	# Returns the request parameter from the content (for POST) or
	# the query parameter from the URL (for GET) or nil.
	# This is needed because Rails doesn't pass a request argument
	# named 'action' to the params array as it overrides the
	# "action" arg.!
	# 
	def _arg( name )
		name = name.to_sym
		return request.request_parameters[name] || request.query_parameters[name]
	end
	
	def _args()
		return (request.request_parameters.length > 0) \
			? request.request_parameters \
			: request.query_parameters
	end
	
	def _bold( str )
		return "\e[0;32;1m#{str} \e[0m "
	end
	
)end
