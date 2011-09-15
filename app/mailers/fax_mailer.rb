class FaxMailer < ActionMailer::Base
	default :from => Configuration.get(:smarthost_from_address, 'Gemeinschaft4')
	
	def new_fax_document(fax_document)
		@user = fax_document.user
        @fax_document = fax_document
		
		if @user
			file_path = @fax_document.pdf_file_path
			if (! file_path)
				file_path =  @fax_document.to_pdf
				
			end
			if (file_path)
				file_name = File.basename(@fax_document.file, File.extname(@fax_document.file)) + '.pdf'
			end
			
			attachments[file_name] = File.read(file_path)
			mail(:to => "#{@user.gn} #{@user.sn} <#{@user.email}>", :subject => t(:fax_email_subject, :source => @fax_document.source, :destination => @fax_document.destination))
		end
	end
end
