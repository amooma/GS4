module XmlRpc
	
	def self.request(method, arguments)
		require 'xmlrpc/client'
		
		xml_rpc_host      = Configuration.get(:xml_rpc_host, '127.0.0.1' )
		xml_rpc_port      = Configuration.get(:xml_rpc_port, 8080 )
		xml_rpc_user      = Configuration.get(:xml_rpc_user )
		xml_rpc_password  = Configuration.get(:xml_rpc_password )
		xml_rpc_directory = Configuration.get(:xml_rpc_directory, '/RPC2' )
		xml_rpc_api       = Configuration.get(:xml_rpc_api, 'freeswitch.api' )
		xml_rpc_timeout   = Configuration.get(:xml_rpc_timeout, 10 )
		if (Configuration.get(:xml_rpc_ssl, 'no' ) == 'yes')
			xml_rpc__ssl = true
		else
			xml_rpc__ssl = false
		end
		
		begin
			server = XMLRPC::Client.new(xml_rpc_host, xml_rpc_directory, xml_rpc_port, nil, nil, xml_rpc_user, xml_rpc_password, xml_rpc__ssl, xml_rpc_timeout)
			return server.call(xml_rpc_api, method, arguments)
		rescue
			return false
		end
	end
	
	def self.send_fax(destination, domain, raw_file)
		response = request('originate', "sofia/internal/#{destination}@#{domain};fs_path=sip:127.0.0.1:5060 &txfax(#{raw_file})")
		
		if (!response)
			return false
		end
		
		begin
			return response.strip.split(' ', 2)[1]
		rescue
			return false
		end
	end
	
	def self.voicemails_get(sip_account, domain)
		response = request('vm_list', "#{sip_account}@#{domain} xml")

		if (!response || response == 'ERROR!')
			return false
		end
		
		return Hash.from_xml(response)['voicemail']['message']
	end

	def self.voicemail_set_read(sip_account, domain, uuid, read = true)
		if (read)
			read_status = 'read'
		else
			read_status = 'unread'
		end

		response = request('vm_read', "#{sip_account}@#{domain} #{read_status} #{uuid}")
		if (!response)
			return false
		end
		if (response.strip == "+OK")
			return true
		else
			return false
		end
	end

	def self.voicemail_set_unread(sip_account, domain, uuid)
		return voicemail_set_read(sip_account, domain, uuid, false)
	end
	
	def self.voicemail_delete(sip_account, domain, uuid)
		response = request('vm_delete', "#{sip_account}@#{domain} #{uuid}")
		if (!response)
			return false
		end
		if (response.strip == "+OK")
			return true
		else
			return false
		end
	end
	
	def self.voicemail_get_details(sip_account, domain, uuid)
		require 'json'

		response = request('vm_fsdb_msg_get', "xml default #{domain} #{sip_account} #{uuid}")
		if (!response)
			return false
		end
		begin
			return JSON.parse(response)
		rescue
			return false
		end
	end
end
