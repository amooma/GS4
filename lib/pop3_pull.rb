module Pop3Pull
	
	def self.start
		if ! Configuration.get(:fax_pop3, false, Configuration::Boolean) && Configuration.get(:mailserver_hostname).blank? 
			return false
		end

		require 'net/pop'
		require 'mail_to_fax'
		
		Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if Configuration.get(:mailserver_ssl, true, Configuration::Boolean)
		begin
			Rails::logger.debug( "POP3: Checking mail ..." )
			Net::POP3.start(
				Configuration.get(:mailserver_hostname),
				Configuration.get(:mailserver_port, 110, Integer),
				Configuration.get(:mailserver_username),
				Configuration.get(:mailserver_password)
			) do |pop3|
				if pop3.mails.empty?
					Rails::logger.debug( "POP3: Mailbox \"#{Configuration.get(:mailserver_username)}@#{Configuration.get(:mailserver_hostname)}\" empty ..." )
				else
					Rails::logger.debug( "POP3: Found #{pop3.mails.count} mail(s) in mailbox \"#{Configuration.get(:mailserver_username)}@#{Configuration.get(:mailserver_hostname)}\" ..." )
					pop3.mails.each do |email|
						Rails::logger.debug( "POP3: Retrieving message \"#{email.unique_id}\" ..." )
						begin
							if MailToFax.receive(email.pop)
								email.delete
							end
						rescue Exception => e
							Rails::logger.error( "POP3: Error receiving mail: #{e.message}" )
						end
					end
				end
			end
			
		rescue Exception => e
			Rails::logger.error( "POP3: Error processing mail: #{e.message}" )
		end
	end
	
end
