module XmlRpc
	
	def self.request( method, arguments, background=false, xml_rpc_timeout=nil )
		require 'xmlrpc/client'
		
		xml_rpc_host      = Configuration.get(:xml_rpc_host, '127.0.0.1' )
		xml_rpc_port      = Configuration.get(:xml_rpc_port, 8080 )
		xml_rpc_user      = Configuration.get(:xml_rpc_user )
		xml_rpc_password  = Configuration.get(:xml_rpc_password )
		xml_rpc_directory = Configuration.get(:xml_rpc_directory, '/RPC2' )
		xml_rpc_api       = Configuration.get(:xml_rpc_api, 'freeswitch.api' )
		xml_rpc_timeout ||= Configuration.get(:xml_rpc_timeout, 20 )
		xml_rpc__ssl      =(Configuration.get(:xml_rpc_ssl, 'no' ) == 'yes')
		
		real_method  = method     .to_s.dup
		real_args    = arguments  .to_s.dup
		if background
			real_args    = "#{real_method} #{real_args}"
			real_method  = 'bgapi'
		end
		
		Rails::logger.info(_bold( "XML-RPC request to \"xmlrpc://#{xml_rpc_user}@#{xml_rpc_host}:#{xml_rpc_port}#{xml_rpc_directory};#{xml_rpc_api}.#{method}#{! arguments.empty? ? '?...' : ''}\" ... (timeout: #{xml_rpc_timeout} s)" ))
		Rails::logger.info( "(Params: #{arguments.inspect})" )
		
		error_msg = nil
		begin
			t0 = Time.now()
			
			xmlrpc_client = XMLRPC::Client.new( xml_rpc_host, xml_rpc_directory, xml_rpc_port, nil, nil, xml_rpc_user, xml_rpc_password, xml_rpc__ssl, xml_rpc_timeout )
			response = xmlrpc_client.call( xml_rpc_api, real_method, real_args )
			
			t1 = Time.now()
			Rails::logger.info( "XML-RPC request took #{ (t1.to_f - t0.to_f).round(3) } s." )
			
			if background
				# Return the Job-UUID for bgapi commands.
				if matchdata = response.match( /^\s*[+]?\s*OK\s+Job-UUID\s*:\s*(?<uuid>[0-9a-f\-]+)/i )
					response = matchdata['uuid']
				else
					response = false
				end
			end
			
			return response
			
		rescue Errno::ECONNREFUSED => e
			error_msg = "Failed to connect to XML-RPC service (#{xml_rpc_host}:#{xml_rpc_port}). ECONNREFUSED: #{e.message}"
		rescue Errno::EHOSTUNREACH => e
			error_msg = "Failed to connect to XML-RPC service (#{xml_rpc_host}:#{xml_rpc_port}). EHOSTUNREACH: #{e.message}"
		rescue Timeout::Error => e
			error_msg = "XML-RPC request to \"xmlrpc://#{xml_rpc_user}@#{xml_rpc_host}:#{xml_rpc_port}#{xml_rpc_directory};#{xml_rpc_api}.#{method}\" failed. (timeout, > #{xml_rpc_timeout} s)"
		rescue XMLRPC::FaultException => e
			error_msg = "XML-RPC error: #{e.faultCode} #{e.faultString}"
		rescue SocketError => e
			error_msg = "XML-RPC request to \"#{xml_rpc_host}:#{xml_rpc_port}\" failed. #{e.class.to_s}: #{e.message}"
		rescue => e
			error_msg = "XML-RPC request failed. #{e.class.to_s}: #{e.message}"
		end
		Rails::logger.error(_bold( error_msg )) if error_msg
		return false
	end
	
	def self.send_fax( destination, domain, raw_file, caller_id_num = '', caller_id_name = '', retries = 1, retry_seconds = 60, fax_document_id = nil )
		channel_variables = Hash.new
		channel_variables['api_hangup_hook']              = "system /opt/freeswitch/scripts/fax_store.sh update #{fax_document_id}" if fax_document_id
		channel_variables['originate_retries']            = retries		
		channel_variables['originate_retry_sleep_ms']     = retry_seconds * 1000
		channel_variables['origination_caller_id_number'] = caller_id_num
		channel_variables['origination_caller_id_name']   = caller_id_name if caller_id_name
		channel_variables['origination_caller_id_name']   = caller_id_num if ! caller_id_name
		channel_variables['fax_ident']                    = caller_id_num
		channel_variables['fax_header']                   = caller_id_name 
		channel_variables_s = channel_variables.collect { |key, value| "#{key}='#{value}'" }.join(',')
		response = request('originate', "{#{channel_variables_s}}sofia/internal/#{destination}@#{domain};fs_path=sip:127.0.0.1:5060 &txfax(#{raw_file})")
		
		if (! response)
			return false
		end
		
		begin
			return response.strip.split(' ', 2)[1]
		rescue
			return false
		end
	end
	
	def self.sofia_profile_reload_and_restart( profile )
		if ! profile.match( /^[a-zA-Z0-9\-_.]+$/ ); return false; end
		
		Rails.logger.info( "Reloading and restarting Sofia SIP user-agent #{profile.inspect} ..." )
		
		# Reload an restart the Sofia profile as a background job because
		# otherwise the request would block for more than 60 seconds.
		response = request( 'sofia', "profile '#{profile}' restart reloadxml", true )
		return response
	end
	
	def self.sofia_gateway_states( profile = nil )
		response = request( 'sofia', "xmlstatus gateway" )
		
		if (! response || response == 'ERROR!'); return false; end
		
		begin
			h = Hash.from_xml( response )
		rescue REXML::ParseException => e
			Rails.logger.warn( "Failed to parse the XML-RPC response from FreeSwitch. #{e.message}" )
			return false
		end
		
		if ! h || ! h['gateways']; return false; end
		
		# If there are no gateways we don't want to return
		# nil but an empty array:
		gws = []
		
		if h['gateways'].kind_of?( Hash )
			if           h['gateways']['gateway'].kind_of?( Array )
				gws =    h['gateways']['gateway']
			elsif        h['gateways']['gateway'].kind_of?( Hash )
				gws =  [ h['gateways']['gateway'] ]
			end
		end
		
		gws.select!{ |gw| gw['profile'] == profile } if profile
		
		return gws
	end
	
	def self.voicemails_get( sip_account, domain )
		response = request('vm_list', "#{sip_account}@#{domain} xml")
		
		# response is a string and look like this:
		# <voicemail>
		# 	<message>
		# 		...
		# 	</message>
		# 	<message>
		# 		...
		# 	</message>
		# </voicemail>
		# 
		# Without messages (no surprise):
		# <voicemail>
		# </voicemail>
		
		if (! response || response == 'ERROR!')
			return false
		end
		
		begin
			h = Hash.from_xml( response )
		rescue REXML::ParseException => e
			Rails.logger.warn( "Failed to parse the XML-RPC response from FreeSwitch. #{e.message}" )
			return false
		end
		
		# The hash looks like this:
		# {
		# 	"voicemail" => {
		# 		"message" => [
		# 			{
		# 				...
		# 			},
		# 			{
		# 				...
		# 			}
		# 		]
		# 	}
		# }
		# Without messages (surprise!):
		# {
		# 	"voicemail" => "\n"
		# }
		
		if ! h || ! h['voicemail']
			return false
		end
		
		# If there are no voicemail messages we don't want to return
		# nil but an empty array:
		vms = []
		
		if h['voicemail'].kind_of?( Hash )
			if           h['voicemail']['message'].kind_of?( Array )
				vms =    h['voicemail']['message']
			elsif        h['voicemail']['message'].kind_of?( Hash )
				vms =  [ h['voicemail']['message'] ]
			end
		end
		
		return vms
	end
	
	def self.voicemail_set_read( sip_account, domain, uuid, read = true )
		if (read)
			read_status = 'read'
		else
			read_status = 'unread'
		end
		
		response = request('vm_read', "#{sip_account}@#{domain} #{read_status} #{uuid}")
		if (! response)
			return false
		end
		if (response.strip == "+OK")
			return true
		else
			return false
		end
	end
	
	def self.voicemail_set_unread( sip_account, domain, uuid )
		return voicemail_set_read( sip_account, domain, uuid, false )
	end
	
	def self.voicemail_delete(sip_account, domain, uuid)
		response = request('vm_delete', "#{sip_account}@#{domain} #{uuid}")
		if (! response)
			return false
		end
		if (response.strip == "+OK")
			return true
		else
			return false
		end
	end
	
	def self.voicemail_get_details( sip_account, domain, uuid )
		require 'json'
		
		response = request('vm_fsdb_msg_get', "xml default #{domain} #{sip_account} #{uuid}")
		if (! response)
			return false
		end
		begin
			return JSON.parse(response)
		rescue
			return false
		end
	end
	
	def self._bold( str )
		return "\e[0;32;1m#{str} \e[0m "
	end
	
end
