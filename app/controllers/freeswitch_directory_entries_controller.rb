class FreeswitchDirectoryEntriesController < ApplicationController
(
	# Allow access from 127.0.0.1 and [::1] only.
	prepend_before_filter { |controller|
		if ! request.local?
			if user_signed_in?  #OPTIMIZE && is admin
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
	
	# Examples:
	# Request domains and gateways:
	#  /freeswitch-directory-entries/search.xml?section=directory&purpose=gateways
	# Request users with ACL rules:
	#  /freeswitch-directory-entries/search.xml?section=directory&purpose=network-list
	# Request an account entry (for SIP authentication / voicemail / dial-by-username):
	#  /freeswitch-directory-entries/search.xml?section=directory&key=id&user=USER&domain=DOMAIN&action=sip_auth
	#  /freeswitch-directory-entries/search.xml?section=directory&key=id&user=USER&domain=DOMAIN&action=message-count
	#  /freeswitch-directory-entries/search.xml?section=directory&key=id&user=USER&domain=DOMAIN&action=user_call
	
	# GET  /freeswitch-directory-entries/search.xml
	# POST /freeswitch-directory-entries/search.xml
	def search()
	(
		if (_arg(:section) != 'directory'); (
			
			logger.warn(_bold( "[FS] Expected section=directory." ))
			
			respond_to { |format|
				format.xml {
					render :empty_result, :layout => false,
						:locals => { :msg => "Expected section=directory." }
				}
				format.all {
					render :status => '406 Not Acceptable',
						:layout => false, :content_type => 'text/plain',
						:text => "<!-- Only XML format is supported. -->"
				}
			}
			return
		)end
		
		if (_arg(:purpose) && _arg(:purpose) == 'gateways'); (
			# list gateways and domain aliases (as in the Sofia SIP profile)
			# http://wiki.freeswitch.org/wiki/Mod_xml_curl#Startup
			
			logger.info(_bold( "[FS] Request for domains and gateways ..." ))
			
			#@sip_servers = SipServer.all( :group => :host )
			
			respond_to { |format|
				format.xml {
					#render :domains_and_gateways_index, :layout => false
					render :empty_result, :layout => false
				}
				format.all {
					render :status => '406 Not Acceptable',
						:layout => false, :content_type => 'text/plain',
						:text => "<!-- Only XML format is supported. -->"
				}
			}
			return
		)end
		
		if (_arg(:purpose) && _arg(:purpose) == 'network-list'); (
			# list ACL rules? users with ACL rules (cidr)?
			# http://wiki.freeswitch.org/wiki/Mod_xml_curl#ACL
			
			logger.info(_bold( "[FS] Request for users with ACL rules ..." ))
			
			respond_to { |format|
				format.xml {
					#render :network_list_index, :layout => false
					render :empty_result, :layout => false
				}
				format.all {
					render :status => '406 Not Acceptable',
						:layout => false, :content_type => 'text/plain',
						:text => "<!-- Only XML format is supported. -->"
				}
			}
			return
		)end
		
		if (_arg(:key) && _arg(:key) == 'id' && _arg(:user) && _arg(:domain)); (
			# user directory entry, used for voicemail as well
			# http://wiki.freeswitch.org/wiki/Mod_xml_curl#Authorization
			# http://wiki.freeswitch.org/wiki/Mod_xml_curl#Voicemail_request
			# or dial by user/<username> request for user item
			# http://wiki.freeswitch.org/wiki/Mod_xml_curl#Dial_by_user.2F.3Cusername.3E_Request
			
			# Damn Rails doesn't pass a request argument named 'action'
			# to the params array because it overrides the "action" arg.!
			
			type = case _arg(:action)
				when 'sip_auth'      then 'sip-auth'
				when 'message-count' then 'voicemail'
				when 'user_call'     then 'dial-by-username'
				else
					if (_arg(:as_channel) && _arg(:as_channel).match(/^true|1$/i))
						'dial-by-username'
					else
						'unknown'
					end
			end
			
			logger.info(_bold( "[FS] Request for user #{_arg(:user)}@#{_arg(:domain)} (for #{type}) ..." ))
			
			# Find the SIP account:
			# Find SIP account by auth_name:
			@sip_account = nil
			if ! @sip_account
				@sip_account = SipAccount.where({
					:auth_name      => _arg(:user)
				}) #\ #OPTIMIZE Use domain as well once multiple domains are implemented.
				#.joins(:sip_server).where(:sip_servers => {
				#	:host           => _arg(:domain)
				#}).first
			end
			## Find SIP account by extension (this is now done by Kamailio):
			#if ! @sip_account
			#	@sip_account = SipAccount.where({
			#	}).joins(:sip_server).where(:sip_servers => {
			#		:host           => _arg(:domain)
			#	}).joins(:extension).where(:extensions => {
			#		:extension      => _arg(:user)
			#	}).first
			#end
			
			#puts "-------------------{"
			#puts @sip_account.inspect
			#puts "-------------------}"
			
			respond_to { |format|
				format.xml {
					if (@sip_account)
						render :account_show, :layout => false
					else
						render :empty_result, :layout => false
					end
				}
				format.all {
					render :status => '406 Not Acceptable',
						:layout => false, :content_type => 'text/plain',
						:text => "<!-- Only XML format is supported. -->"
				}
			}
			return
		)end
		
		logger.warn(_bold( "[FS] Unknown request!" ))
		
		respond_to { |format|
			format.xml {
				render :empty_result, :layout => false
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
	
	def _bold( str )
		return "\e[0;1m#{str} \e[0m "
	end
	
	
)end
