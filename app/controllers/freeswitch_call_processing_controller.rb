# ruby encoding: utf-8

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
		sip_call_id           = _arg( 'var_sip_call_id' )
		
		src_sip_user          = _arg( 'var_sip_from_user' )  # / var_sip_from_user_stripped ?
		
		src_cid_sip_domain    = _arg( 'var_sip_from_host' )
		#src_sip_user          = _arg( 'Caller-Username' )
		src_cid_sip_user      = _arg( 'Caller-Caller-ID-Number' )
		src_cid_sip_display   = _arg( 'var_sip_from_display' )  # Caller-Caller-ID-Name is not always present
		
		dst_sip_user          = _arg( 'Caller-Destination-Number' )  # / var_sip_req_user
		#dst_sip_domain        = _arg( 'var_sip_req_host' )
		dst_sip_domain        = _arg( 'var_sip_to_host' )
		
		dst_sip_dnis_user     = _arg( 'var_sip_to_user' )
		# This is the number as dialed by the caller (before unaliasing in Kamailio).
		
		# Strip "-kambridge-" prefix added in kamailio.cfg:
		dst_sip_user = dst_sip_user.to_s.gsub( /^-kambridge-/, '' )
		
		dst_sip_user_real = dst_sip_user  # un-alias
		# (Alias lookup has already been done in kamailio.cfg.)
		
		call_disposition = _arg( 'var_originate_disposition')
		
		
		forward_reasons = [
			'UNALLOCATED_NUMBER',
			'NO_ROUTE_DESTINATION',
			'USER_BUSY',
			'NO_USER_RESPONSE',
			'NO_ANSWER',
			'CALL_REJECTED',
			'SWITCH_CONGESTION',
			'REQUESTED_CHAN_UNAVAIL',
		]
		busy_reasons = [
			'USER_BUSY',
			'CALL_REJECTED',
		]
		offline_reasons = [
			'NO_ROUTE_DESTINATION',
			'NO_USER_RESPONSE',
			'CALL_REJECTED',
			'SWITCH_CONGESTION',
			'REQUESTED_CHAN_UNAVAIL',
		]
		noanswer_reasons = [
			'NO_ANSWER',
		]
		
		
		src_sip_account = (
			SipAccount.where({
				:auth_name => src_sip_user
			})
			.joins( :sip_server )
			.where( :sip_servers => {
				:host => src_cid_sip_domain
			})
			.first )
		
		dst_sip_account = nil
		dst_conference  = nil
		dst_queue       = nil
		
		if dst_sip_user_real.match( /^-conference-.*/ )
			dst_conference = (
				Conference.where({
					:uuid => dst_sip_user_real
				})
				.first )
		else
			dst_sip_account = (
				SipAccount.where({
					:auth_name => dst_sip_user_real
				})
				.joins( :sip_server )
				.where( :sip_servers => {
					:host => dst_sip_domain
				})
				.first )
		end
		
		logger.info(_bold( "[FS] SIP Call-ID: #{sip_call_id}" ))
		logger.info(_bold( "[FS] Call" \
			<< " from #{ sip_displayname_quote( src_cid_sip_display )}" \
			<< " <#{ sip_user_encode( src_cid_sip_user )}@#{ src_cid_sip_domain }>" \
			<< " (SIP acct. " << (src_sip_account ? "##{ src_sip_account.id }" : "unknown").to_s << ")" \
			<< " to" \
			<< " alias <#{ sip_user_encode( dst_sip_dnis_user )}> ->" \
			<< " <#{ sip_user_encode( dst_sip_user )}@#{ dst_sip_domain }>" \
			<< " (SIP acct. " << (dst_sip_account ? "##{ dst_sip_account.id }" : "unknown").to_s << ")" \
			<< " ..."
		))
		
		if src_sip_account
			logger.info(_bold( "[FS] Source account is #{ sip_user_encode( src_sip_user )}@#{ src_cid_sip_domain }" ))
			action :set_user, "#{ sip_user_encode( src_sip_user )}@#{ src_cid_sip_domain }"
		end
		
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
		
		
		# For FreeSwitch dialplan applications see
		# http://wiki.freeswitch.org/wiki/Mod_dptools
		# http://wiki.freeswitch.org/wiki/Category:Dptools
		
		# Note: If you want to do multiple iterations (requests) you
		# have to set channel variables to keep track of "where you
		# are" i.e. what you have done already.
		# And you have to explicitly send "_continue" as the last
		# application.
		
		
		if dst_sip_user   .blank? \
		&& dst_conference .blank?
			case _arg( 'Answer-State' )
				when 'ringing'
					action :respond   , '404 Not Found'  # or '400 Bad Request'? or '484 Address Incomplete'?
				else
					action :hangup    , ''
			end
		else (
			# Here's an example: {
			#action :set       , 'effective_caller_id_number=1234567'
			#action :bridge    , "sofia/internal/#{dst_sip_user_real}"
			#action :answer
			#action :sleep     , 1000
			#action :playback  , 'tone_stream://%(500, 0, 640)'
			#action :set       , 'voicemail_authorized=${sip_authorized}'
			#action :voicemail , "default $${domain} #{dst_sip_user_real}"
			#action :hangup
			#action :_continue
			# end of example }
			
			
			if forward_reasons.include? call_disposition ; (
				if ! dst_sip_user.blank? ; (
					
					if busy_reasons.include? call_disposition
						
						call_forward = CallForward.where({
								:sip_account_id => dst_sip_account.id,
								:active         => true,
								:source         => "#{src_cid_sip_user}"
							}).joins( :call_forward_reason ).where({
								:call_forward_reasons => { :value => "busy" }
							}).first
						
						if ! call_forward
							call_forward_always = CallForward.where({
									:sip_account_id => dst_sip_account.id,
									:active         => true,
									:source         => ""
								}).joins( :call_forward_reason ).where({
									:call_forward_reasons => { :value => "busy" }
								}).first 
						end
						
						if call_forward_always
							if call_forward_always.destination == "voicemail"
								call_forward_always.destination	= "-vbox-#{dst_sip_user_real}"
							end
							
							if call_forward_always.destination.blank?
								action :respond , "480 Blacklisted"
							else
								action :transfer , "#{call_forward_always.destination} XML default"
							end
						end
						
					elsif offline_reasons.include? call_disposition
						
						call_forward = CallForward.where(
								:sip_account_id => dst_sip_account.id,
								:active => true,
								:source => "#{src_cid_sip_user}"
							).joins( :call_forward_reason ).where(
								:call_forward_reasons => { :value => "offline"}
							).first
						
						if ! call_forward
							call_forward_always = CallForward.where(
									:sip_account_id => dst_sip_account.id,
									:active => true,
									:source => ""
								).joins( :call_forward_reason ).where(
									:call_forward_reasons => { :value => "offline"}
								).first 
						end
						
						if call_forward_always
							if call_forward_always.destination == "voicemail"
								call_forward_always.destination	= "-vbox-#{dst_sip_user_real}"
							end
							
							if call_forward_always.destination.blank?
								action :respond , "480 Blacklisted"
							else
								action :transfer , "#{call_forward_always.destination} XML default"
							end
						end
						
					elsif noanswer_reasons.include? call_disposition
						
						call_forward = CallForward.where(
								:sip_account_id => dst_sip_account.id,
								:active => true,
								:source => "#{src_cid_sip_user}"
							).joins( :call_forward_reason ).where(
								:call_forward_reasons => { :value => "noanswer"}
							).first
						
						if ! call_forward
							call_forward_always = CallForward.where(
									:sip_account_id => dst_sip_account.id,
									:active => true,
									:source => ""
								).joins( :call_forward_reason ).where(
									:call_forward_reasons => { :value => "noanswer"}
								).first 
						end
						
						if call_forward_always
							if call_forward_always.destination == "voicemail"
								call_forward_always.destination	= "-vbox-#{dst_sip_user_real}"
							end
							
							if call_forward_always.destination.blank?
								action :respond, "480 Blacklisted"
							else
								action :transfer, "#{call_forward_always.destination} XML default"
							end
						end
						
					else
						action :hangup, ''
					end
				)end
				#return	# OPTIMIZE Double check for better solution.
			)end
			
			
			# Caller-ID:
			# Note: P-Asserted-Identity is set in Kamailio.
			#
			action :set, "sip_cid_type=none"  # do not send P-Asserted-Identity
			
			clir = false  #OPTIMIZE Read from SIP account.
			if ! clir
				if src_sip_account
					cid_display = src_sip_account.caller_name
					extensions  = src_sip_account.extensions.where( :active => true )
					preferred_extension = extensions.first  #OPTIMIZE Depends on the gateway.
					cid_user    = preferred_extension ? "#{preferred_extension.extension}" : 'anonymous'
				else
					cid_display = "[?] #{src_cid_sip_display}"
					cid_user    = "#{src_sip_user}"
				end
				cid_host    = "#{dst_sip_domain}"  #OPTIMIZE
			else
				cid_display = "Anonymous"  # RFC 2543, RFC 3325
				cid_user    = 'anonymous'  # RFC 2543, RFC 3325
				cid_host    = "anonymous.invalid"  # or "127.0.0.1"
			end
			
			# RFC 2543:
			action :set, "effective_caller_id_number=#{ sip_user_encode( cid_user )}"
			action :set, "effective_caller_id_name=#{ sip_displayname_encode( cid_display )}"
			# RFC 3325:
			action :set, "sip_h_P-Preferred-Identity=#{ sip_displayname_quote( cid_display )} <sip:#{ sip_user_encode( cid_user )}@#{ cid_host }>"
			# RFC 3325, RFC 3323:
			action :set, "sip_h_Privacy=" << ((!clir) ? 'none' : 'id;header')
			
			
			# Call-forwardings:
			#
			if dst_sip_account
				
				call_forward_always = CallForward.where(
						:sip_account_id => dst_sip_account.id,
						:active => true,
						:source => "#{src_cid_sip_user}"
					).joins( :call_forward_reason ).where(
						:call_forward_reasons => { :value => "always"}
					).first
				
				if ! call_forward_always
					call_forward_always = CallForward.where(
							:sip_account_id => dst_sip_account.id,
							:active => true,
							:source => ""
						).joins( :call_forward_reason ).where(
							:call_forward_reasons => { :value => "always"}
						).first 
				end
				
				if call_forward_always
					if call_forward_always.destination == "voicemail"
						call_forward_always.destination	= "-vbox-#{dst_sip_user_real}"
					end
					
					if call_forward_always.destination.blank?
						action :respond , "480 Blacklisted"
					else
						action :transfer , "#{call_forward_always.destination} XML default"
					end
				end
			end
			
			# Ring the SIP user via Kamailio for 30 seconds:
			#
			if dst_sip_account 
				action_log( FS_LOG_INFO, "Calling #{dst_sip_user_real} ..." )
				action :set       , "call_timeout=30"  #OPTIMIZE Read from CF-after-timeout
				action :export    , "sip_contact_user=ufs"
				action :bridge    , "sofia/internal/#{sip_user_encode( dst_sip_user_real )}@#{dst_sip_domain};fs_path=sip:127.0.0.1:5060"
			elsif dst_conference
				action_log( FS_LOG_INFO, "Calling #{dst_sip_user_real} ..." )
				action :conference	, "#{dst_conference.uuid}@default+#{dst_conference.pin}"
			end
			
			
			# Go to voicemail:
			#
			if dst_sip_account
				if ! dst_sip_account.voicemail_server
					action_log( FS_LOG_INFO, "SIP account #{dst_sip_user_real} doesn't have a voicemail server." )
				else
					if ! dst_sip_account.voicemail_server.is_local
						action_log( FS_LOG_INFO, "Voicemail server of SIP account #{dst_sip_user_real} isn't local." )
						action :respond, "480 No voicemail here"  #OPTIMIZE
					else
						#if dst_sip_account.voicemail_server.host != dst_sip_domain
						#	action_log( FS_LOG_INFO, "Voicemail server of SIP account #{dst_sip_user_real} is local but #{dst_sip_account.voicemail_server.host.inspect} != #{dst_sip_domain.inspect}." )
						#	action :respond, "480 No voicemail here"  #OPTIMIZE
						#else
							action_log( FS_LOG_INFO, "Going to voicemail for #{dst_sip_user_real}@#{dst_sip_domain} ..." )
							action :answer
							action :sleep, 250
							action :set, "voicemail_alternate_greet_id=#{ sip_user_encode( dst_sip_dnis_user )}"
							action :voicemail, "default #{dst_sip_domain} #{sip_user_encode( dst_sip_user_real )}"
						#end
					end
				end
			end
			
			action :hangup
			#action :_continue
			
		)end
		
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
	
	# Encode special characters in a SIP username.
	# See the "user" rule in http://tools.ietf.org/html/rfc3261 .
	#
	def sip_user_encode( str )  #OPTIMIZE
		str = str.to_s
		
		# Sanitize control characters. They could be encoded but cause
		# problems for many implementations:
		str = str.gsub( /[\x00-\x1F]+/, ' ' )
		
		# FreeSwitch doesn't handle " " even in its encoded form:
		str = str.gsub( / +/, '' )
		
		#unsafe = /[^a-zA-Z0-9\-_.!~*'()&=+$,;?\/]/
		unsafe = /[^a-zA-Z0-9\-_.!~*'()&=+$,;?]/  # without "/" (which are special for FreeSwitch)
		return percent_encode_re( str, unsafe )
	end
	
	#OPTIMIZE We may want to add a sip_tel_subscriber_encode() method
	# which refers to the "telephone-subscriber" rule from
	# http://tools.ietf.org/html/rfc3261 .
	
	# Encode special characters in a SIP display-name.
	# See the "display-name"/"qdtext"/"quoted-pair" rules in
	# http://tools.ietf.org/html/rfc3261 .
	#
	def sip_displayname_encode( str )
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
			ret << percent_encode_re( str[ pos, safe_part.begin(0)-pos ], /./ )
			
			# add the safe part:
			ret << safe_part.to_s
			
			pos = safe_part.end(0)
		end
		ret = ret.join('')
		ret = ret[ 0, ret.bytesize-1 ].force_encoding( Encoding::UTF_8 )
		#logger.debug( "sip_displayname_encode( #{orig_str.inspect} )  =>  #{ret.inspect}" )
		return ret
	end
	
	# Like sip_displayname_encode() but enclosed in double quotes.
	# Returns an empty string (no quotes) for .blank?() strings
	#
	def sip_displayname_quote( str )
		return '' if str.blank?
		return '"' << sip_displayname_encode( str ).to_s << '"'
	end
	
	def percent_encode_re( str, re_unsafe )
		return str.to_s.gsub( re_unsafe ) {
			unsafe_char = $&
			esc = ''
			unsafe_char.each_byte { |ub|
				esc << sprintf('%%%02X', ub)  # must be uppercase!
			}
			esc
		}.force_encoding( Encoding::US_ASCII )
	end
	
)end
