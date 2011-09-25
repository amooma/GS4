class MailToFax < ActionMailer::Base
	
	def receive( email )
		Rails::logger.debug( "MailToFax: Processing mail From: #{email.from}, Subject: \"#{email.subject}\" ..." )
		user = User.where( :role => :user, :email => email.from ).first
		if user && email.has_attachments?
			Rails::logger.debug( "MailToFax: #{email.attachments.count} attachment(s) found in email assigned to \"#{user.to_display}\" ..." )
			email.attachments.each do |attachment|
				file_base_name = "#{File.basename( Configuration.get( :fax_outgoing_file_prefix, 'fax_out_' ))}#{SecureRandom.hex(10)}"
				pdf_suffix = File.basename( Configuration.get( :fax_pdf_suffix, '.pdf' ))
				pdf_file = File.expand_path( "#{Configuration.get( :fax_files_directory )}/#{file_base_name}#{pdf_suffix}" )
				Rails::logger.debug( "MailToFax: Saving attachment \"#{attachment.original_filename}\" to \"#{pdf_file}\" ..." )
				begin 
					file = File.new( pdf_file, "wb" )
					file.write( attachment.decoded )
					file.close
				rescue Exception => e
					Rails::logger.error( "MailToFax: Error processing attachment \"#{pdf_file}\": #{e.message}" )
				end
				fax = FaxDocument.new()
				if fax.to_raw( pdf_file, attachment.original_filename )
					fax.outgoing = true
					fax.destination = email.subject
					fax.source = user.extensions.first.extension if user.extensions.first
					fax.user = user
					if ( fax.save && ! fax.destination.blank? )
						Rails::logger.debug( "MailToFax: Sending fax from: \"#{fax.source}\" to: \"#{fax.destination}\" ..." )
						if ! fax.transfer( fax.destination )
							Rails::logger.warn( "MailToFax: Fax could not be sent to \"#{fax.destination}\"" )
						end	
					end
					if ! fax.errors.blank?
						Rails::logger.error( "MailToFax: Error(s) in fax document: #{fax.errors}" )
					end
				else
					Rails::logger.warn( "MailToFax: Could not create fax file from document \"#{attachment.original_filename}\" ..." )
				end
				
				File.unlink( pdf_file )
			end
		else
			Rails::logger.warn( "MailToFax: No user found for email address #{email.from}" ) if ! user
			Rails::logger.warn( "MailToFax: No attachment found in email from #{email.from}" ) if ! email.has_attachments?
		end
	end
	
end
