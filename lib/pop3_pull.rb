module Pop3Pull

	def self.start
		if ! Configuration.get(:fax_pop3, false, Configuration::Boolean) && Configuration.get(:mailserver_hostname).blank? 
			return false
		end

		require 'net/pop'
		require 'mail_to_fax'

		Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if Configuration.get(:mailserver_ssl, true, Configuration::Boolean)
		begin
			Net::POP3.start(
				Configuration.get(:mailserver_hostname),
				Configuration.get(:mailserver_port, 110, Integer),
				Configuration.get(:mailserver_username),
				Configuration.get(:mailserver_password)
			) do |pop3|
				if ! pop3.mails.empty?
					pop3.mails.each do |email|
						begin
							MailToFax.receive(email.pop)
							email.delete
						rescue Exception => e
							Rails::logger.error( "Error receiving mail: #{e.message}" )
						end
					end
				end
			end

		rescue Exception => e
			Rails::logger.error( "Error processing mail: #{e.message}" )
		end
	end
	
end