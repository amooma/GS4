class MailToFax < ActionMailer::Base
	
	def receive( email )
		user = User.where( :role => :user, :email => email.from ).first
		if user && email.has_attachments?
			email.attachments.each do |attachment|
				file_base_name = "#{File.basename( Configuration.get( :fax_outgoing_file_prefix, 'fax_out_' ))}#{SecureRandom.hex(10)}"
				pdf_suffix = File.basename( Configuration.get( :fax_pdf_suffix, '.pdf' ))
				pdf_file = File.expand_path( "#{Configuration.get( :fax_files_directory )}/#{file_base_name}#{pdf_suffix}" )
				file = File.new( pdf_file, "wb" )
				file.write( attachment.decoded )
				file.close
				fax = FaxDocument.new()
				if fax.to_raw( pdf_file, attachment.original_filename )
					fax.outgoing = true
					fax.destination = email.subject
					fax.source = user.extensions.first.extension if user.extensions.first
					fax.user = user
					if ( fax.save && ! fax.destination.blank? )
						fax.transfer( fax.destination )
					end
				end	
				File.unlink( pdf_file )
			end
		end
	end
	
end
