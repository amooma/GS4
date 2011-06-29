class FaxDocument < ActiveRecord::Base
	
	#TODO Make FaxDocuments associated to something. (SipAccounts? Users?)
	
	validates_presence_of     :raw_file
	validates_presence_of     :file
	
	before_validation( :on => :create ) {
		if (! self.raw_file)
			self.create_raw_file_from_document()
		end
		if (self.raw_file)
			raw_file = "#{FAX_FILES_DIRECTORY}/#{self.raw_file}.tif"
			if (! self.raw_file)
				errors.add( :base, "No document found")
			elsif (! File.exists?(raw_file))
				errors.add( :base, "Failed to convert document")
			else
				thumbnail = "#{FAX_FILES_DIRECTORY}/#{self.raw_file}.png"
				if (! File.exists?(thumbnail))
					create_thumbnail_from_fax( self.raw_file )
				end
				if (! self.destination.blank?)
					originate_call(self.destination, raw_file)
				end
			end
		else
	       errors.add( :base, "Fax document could not be created")
		end
	}
	
	after_validation( :on => :update ) {
		if outgoing
			raw_file = "#{FAX_FILES_DIRECTORY}/#{self.raw_file}.tif"
			if (! self.raw_file || ! File.exists?(raw_file))
				errors.add( :base, "Fax document not found")
			elsif (! self.destination.blank?)
				originate_call(self.destination, raw_file)
			end
		end
	}
	
	before_destroy {
		raw_file = "#{FAX_FILES_DIRECTORY}/#{self.raw_file}"
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
			errors.add( :base, "Fax source document does not exist")
			return false
		end
		resolution = '204x98'
		page_size = '1728x1078'
		output_file = "FAX-OUT-#{SecureRandom.hex(10)}"
		output_path = "#{FAX_FILES_DIRECTORY}/#{output_file}"
		if (File.exist?(output_path+'.tif'))
			errors.add( :base, "Fax file already exists")
			return false
		end
		
		#create fax g3 file
		system "gs -q -r#{resolution} -g#{page_size} -dNOPAUSE -dBATCH -dSAFER -sDEVICE=tiffg3 -sOutputFile=#{output_path}.tif -- #{input_file}"
		if (! File.exist?(output_path+'.tif'))
			system "convert -density 204x98 -resize 1728x1186\! -monochrome -compress Fax #{input_file} #{output_path}.tif"
		end
		
		#create fax png thumbnail
		system "gs -q -r21x31 -g210x310 -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pngmono -sOutputFile=#{output_path}.png -- #{input_file}"
		if (File.exist?(output_path+'.tif') && ! File.exist?(output_path+'.png'))
			system "convert -resize 210x310\! #{output_path}.tif #{output_path}.png"
		end
		
		#check if all fallbacks failed and the files are still not present
		if (! File.exist?(output_path+'.tif'))
			errors.add( :base, "Fax file could not be created")
		end
		if (! File.exist?(output_path+'.png'))
			errors.add( :base, "Fax thumbnail could not be created")
		end
		
		self.raw_file = output_file
		self.file = original_filename
		return true
	end
	
	def create_thumbnail_from_fax( raw_file )
		return system "convert -resize 210x310\! #{FAX_FILES_DIRECTORY}/#{raw_file}.tif #{FAX_FILES_DIRECTORY}/#{raw_file}.png"
	end
	
	def originate_call( destination, raw_file )
		require 'net/http'
		
		request_path = "/webapi/originate?sofia/internal/#{destination}@#{DOMAIN};fs_path=sip:127.0.0.1:5060%20&txfax(#{raw_file})"
		
		http = Net::HTTP.new(XML_RPC_HOST, XML_RPC_PORT)
		request = Net::HTTP::Get.new(request_path, nil )
		request.basic_auth(XML_RPC_USER , XML_RPC_PASSWORD)
		response = http.request( request )
	end

		
end
