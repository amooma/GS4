class FreeswitchCallProcessingController < ApplicationController
(
	#before_filter :authenticate_user!
	#FIXME Implement SSL with client certificates.
	
	# GET  /freeswitch-call-processing/actions.xml
	# POST /freeswitch-call-processing/actions.xml
	def actions()
	(
		call_src_sip_username     = _arg( 'Caller-Username' )
		call_src_cid_userinfo     = _arg( 'Caller-Caller-ID-Number' )
		call_src_cid_displayname  = _arg( 'Caller-Caller-ID-Name' )
		call_dst_sip_userinfo     = _arg( 'Caller-Destination-Number' )
		
		logger.info(_bold( "[FS] Call-proc. request, acct. #{call_src_sip_username.inspect} as #{call_src_cid_userinfo.inspect} (#{call_src_cid_displayname.inspect}) -> #{call_dst_sip_userinfo.inspect} ..." ))
		_args.each { |k,v|
			case v
				when String
					logger.debug( "   #{k.ljust(36)} = #{v.inspect}" )
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
		
		@dp_actions = []
		
		if call_dst_sip_userinfo.blank?
			case _arg( 'Answer-State' )
				when 'ringing'
					@dp_actions << { :app => :respond   , :data => '404 Not Found' }  # or '400 Bad Request'? or '484 Address Incomplete'?
				else
					@dp_actions << { :app => :hangup    , :data => '' }
			end
		else
			
			call_dst_real_sip_username = call_dst_sip_userinfo  # un-alias ...
			
			#FIXME Just an example ...
			@dp_actions << { :app => :set       , :data => 'effective_caller_id_number=1234567' }
			@dp_actions << { :app => :bridge    , :data => "sofia/internal/#{call_dst_real_sip_username}" }
			@dp_actions << { :app => :answer    , :data => '' }
			@dp_actions << { :app => :sleep     , :data => 1000 }
			@dp_actions << { :app => :playback  , :data => 'tone_stream://%(500, 0, 640)' }
			@dp_actions << { :app => :set       , :data => 'voicemail_authorized=${sip_authorized}' }
			@dp_actions << { :app => :voicemail , :data => "default $${domain} #{call_dst_real_sip_username}" }
			@dp_actions << { :app => :hangup    , :data => '' }
			#@dp_actions << { :app => :_continue }
			
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
		return "\e[0;1m#{str} \e[0m "
	end
	
)end
