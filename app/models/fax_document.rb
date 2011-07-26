class FaxDocument < ActiveRecord::Base
	
	#TODO Make FaxDocuments associated to something. (SipAccounts? Users?)
	
	validates_presence_of     :raw_file
	validates_presence_of     :file
	
	before_validation( :on => :create ) {
		if (! self.raw_file)
			self.create_raw_file_from_document()
		end
		if (self.raw_file)
			raw_file = "#{Configuration.get(:fax_files_directory)}/#{self.raw_file}.tif"
			if (! self.raw_file || ! File.exists?(raw_file))
				errors.add( :base, I18n.t(:fax_document_not_found))
			else
				thumbnail = "#{Configuration.get(:fax_files_directory)}/#{self.raw_file}.png"
				if (! File.exists?(thumbnail))
					thumbnail_size = Configuration.get(:fax_thumbnail_size, '210x310')
					system "convert -resize #{thumbnail_size}\! #{Configuration.get(:fax_files_directory)}/#{raw_file}.tif #{Configuration.get(:fax_files_directory)}/#{raw_file}.png"
				end
				if (! self.destination.blank?)
					originate_call(self.destination, raw_file)
				end
			end
		else
	       errors.add( :base, I18n.t(:fax_document_not_created))
		end
	}
	
	after_validation( :on => :update ) {
		if outgoing
			raw_file = "#{Configuration.get(:fax_files_directory)}/#{self.raw_file}.tif"
			if (! self.raw_file || ! File.exists?(raw_file))
				errors.add( :base, I18n.t(:fax_document_not_found))
			elsif (! self.destination.blank?)
				originate_call(self.destination, raw_file)
			end
		end
	}
	
	before_destroy {
		raw_file = "#{Configuration.get(:fax_files_directory)}/#{self.raw_file}"
		begin
			File.unlink( raw_file + '.tif' )
		rescue
		end
		begin
			File.unlink( raw_file + '.png' )
		rescue
		end
	}
	
	def upload=(file_data)
		@upload = file_data
	end
	
	def create_raw_file_from_document()
		if (@upload && ! @upload.tempfile.path.blank?)
			input_file = @upload.tempfile.path()
			original_filename = @upload.original_filename
		elsif (! self.file.blank?)
			input_file = self.file
			original_filename = File.basename(self.file)
		else
			errors.add( :base, I18n.t(:fax_document_not_found))
			return false
		end
		resolution =  Configuration.get(:fax_default_resolution, '204x98')
		page_size = Configuration.get(:fax_default_page_size, '1728x1078')
		
		output_file = "FAX-OUT-#{SecureRandom.hex(10)}"
		output_path = "#{Configuration.get(:fax_files_directory)}/#{output_file}"
		if (File.exist?(output_path+'.tif'))
			errors.add( :base, I18n.t(:file_exists))
			return false
		end
		
		#create fax g3 file
		system "gs -q -r#{resolution} -g#{page_size} -dNOPAUSE -dBATCH -dSAFER -sDEVICE=tiffg3 -sOutputFile=#{output_path}.tif -- #{input_file}"
		if (! File.exist?(output_path+'.tif'))
			system "convert -density #{resolution} -resize #{page_size}\! -monochrome -compress Fax #{input_file} #{output_path}.tif"
		end
		
		thumbnail_resolution = Configuration.get(:fax_thumbnail_resolution, '21x31')
		thumbnail_size = Configuration.get(:fax_thumbnail_size, '210x310')
		
		#create fax png thumbnail
		system "gs -q -r#{thumbnail_resolution} -g#{thumbnail_size} -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pngmono -sOutputFile=#{output_path}.png -- #{input_file}"
		if (File.exist?(output_path+'.tif') && ! File.exist?(output_path+'.png'))
			system "convert -resize #{thumbnail_size}\! #{output_path}.tif #{output_path}.png"
		end
		
		#check if all fallbacks failed and the files are still not present
		if (! File.exist?(output_path+'.tif'))
			errors.add( :base, I18n.t(:fax_document_not_created))
		end
		if (! File.exist?(output_path+'.png'))
			errors.add( :base, I18n.t(:fax_thumbnail_not_created))
		end
		
		self.raw_file = output_file
		self.file = original_filename
		return true
	end
	
	def originate_call( destination, raw_file )
		if ( sip_server = SipServer.where(:is_local => true).first )
			domain = sip_server.host
		else
			return false
		end
		
		require 'xml_rpc'
		XmlRpc.send_fax(destination, domain, raw_file)
	end
end
