class FreeswitchCallProcessingController < ApplicationController
(
	#before_filter :authenticate_user!
	#FIXME Implement SSL with client certificates.
	
	# GET  /freeswitch-call-processing/actions.xml
	# POST /freeswitch-call-processing/actions.xml
	def actions()
	(
		logger.info(_bold( "[FS] Call processing request ..." ))
		_args.each { |k,v|
			logger.info( "   #{k.ljust(36)} = #{v.inspect}" )
		}
		
		# For FreeSwitch dialplan applications see
		# http://wiki.freeswitch.org/wiki/Mod_dptools
		# http://wiki.freeswitch.org/wiki/Category:Dptools
		
		@dp_actions = []
		
		#FIXME Just an example ...
		@dp_actions << { :app => :set       , :data => 'effective_caller_id_number=1234567' }
		@dp_actions << { :app => :bridge    , :data => 'user/12' }
		@dp_actions << { :app => :answer    , :data => '' }
		@dp_actions << { :app => :sleep     , :data => 1000 }
		@dp_actions << { :app => :playback  , :data => 'tone_stream://%(500, 0, 640)' }
		@dp_actions << { :app => :set       , :data => 'voicemail_authorized=${sip_authorized}' }
		@dp_actions << { :app => :voicemail , :data => 'default $${domain} ${dialed_ext}' }
		@dp_actions << { :app => :hangup    , :data => '' }
		#@dp_actions << { :app => :_continue }
		
		# Note: If you want to do multiple iterations (requests) you
		# have to set channel variables to keep track of "where you
		# are" i.e. what you have done already.
		# And you have to explicitly send "_continue" as the last
		# application.
		
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
