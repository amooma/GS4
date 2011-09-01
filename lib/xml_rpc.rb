module XmlRpc
	
	def self.request( method, arguments )
		require 'xmlrpc/client'
		
		xml_rpc_host      = Configuration.get(:xml_rpc_host, '127.0.0.1' )
		xml_rpc_port      = Configuration.get(:xml_rpc_port, 8080 )
		xml_rpc_user      = Configuration.get(:xml_rpc_user )
		xml_rpc_password  = Configuration.get(:xml_rpc_password )
		xml_rpc_directory = Configuration.get(:xml_rpc_directory, '/RPC2' )
		xml_rpc_api       = Configuration.get(:xml_rpc_api, 'freeswitch.api' )
		xml_rpc_timeout   = Configuration.get(:xml_rpc_timeout, 20 )
		xml_rpc__ssl      =(Configuration.get(:xml_rpc_ssl, 'no' ) == 'yes')
		
		Rails::logger.debug(_bold( "XML-RPC request to \"xmlrpc://#{xml_rpc_user}@#{xml_rpc_host}:#{xml_rpc_port}#{xml_rpc_directory};#{xml_rpc_api}.#{method}#{! arguments.empty? ? '?...' : ''}\" ..." ))
		Rails::logger.debug( "(Params: #{arguments.inspect})" )
		error_msg = nil
		begin
			xmlrpc_client = XMLRPC::Client.new( xml_rpc_host, xml_rpc_directory, xml_rpc_port, nil, nil, xml_rpc_user, xml_rpc_password, xml_rpc__ssl, xml_rpc_timeout )
			return xmlrpc_client.call( xml_rpc_api, method, arguments )
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
	
	def self.send_fax( destination, domain, raw_file )
		response = request('originate', "sofia/internal/#{destination}@#{domain};fs_path=sip:127.0.0.1:5060 &txfax(#{raw_file})")
		
		if (! response)
			return false
		end
		
		begin
			return response.strip.split(' ', 2)[1]
		rescue
			return false
		end
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
		# Without messages (no surprise):
		# <voicemail>
		# </voicemail>
		if (! response || response == 'ERROR!')
			return false
		end
		
		h = Hash.from_xml( response )
	
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
		
		if h['voicemail'].kind_of?( Hash )
			if  h['voicemail']['message'].kind_of?( Array )
				return h['voicemail']['message']
			elsif h['voicemail']['message'].kind_of?( Hash )
				return [ h['voicemail']['message'] ]
			end
		else
			# If there are no voicemail messages we don't want to return
			# nil but an empty array:
			return []
		end
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
