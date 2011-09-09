class FaxDocument < ActiveRecord::Base
	
	belongs_to :user
	
	validates_presence_of :raw_file
	validates_presence_of :file
	
	before_validation( :on => :create ) {
		if (FaxDocument.where(:user_id => self.user_id).count >= Configuration.get(:fax_max_files, 2048, Integer))
			errors.add( :base, I18n.t(:fax_document_too_many, :count => Configuration.get(:fax_max_files)) )
		else
			if (! self.raw_file)
				self.create_raw_file_from_document()
			end
			if (self.raw_file)
				raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
				raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{raw_file_suffix}")
				if (! raw_file || ! File.exists?(raw_file))
					errors.add( :base, I18n.t(:fax_document_not_found))
				else
					thumbnail_suffix = File.basename(Configuration.get(:fax_thumbnail_suffix, '.png'))
					thumbnail_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{thumbnail_suffix}")
					if (! File.exists?(thumbnail_file))
						thumbnail_size = "#{Configuration.get(:fax_thumbnail_width, 210, Integer)}x#{Configuration.get(:fax_thumbnail_height, 310, Integer)}"
						system "convert -quiet -flatten -resize #{thumbnail_size}\! \"#{raw_file}\" \"#{thumbnail_file}\""
					end
					if (self.outgoing && ! self.destination.blank?)
						if (originate_call(self.destination, raw_file) == false)
							delete_fax_files(self.raw_file)
							errors.add( :base, I18n.t(:fax_document_not_sent))
						end
					end
				end
			else
				errors.add( :base, I18n.t(:fax_document_not_created))
			end
		end
	}
	
	after_validation( :on => :update ) {
		if outgoing
			raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
			raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{raw_file_suffix}")
			if (! self.raw_file || ! File.exists?(raw_file))
				errors.add( :base, I18n.t(:fax_document_not_found))
			elsif (! self.destination.blank?)
				if (originate_call(self.destination, raw_file) == false)
					errors.add( :base, I18n.t(:fax_document_not_sent))
				end
			end
		end
	}
	
	before_destroy {
		delete_fax_files(self.raw_file)
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
		resolution =  "#{Configuration.get(:fax_default_horizontal_resolution, 204, Integer)}x#{Configuration.get(:fax_default_vertical_resolution, 98, Integer)}"
		page_size = "#{Configuration.get(:fax_default_page_width, 1728, Integer)}x#{Configuration.get(:fax_default_page_height, 1078, Integer)}"
		raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
		thumbnail_suffix = File.basename(Configuration.get(:fax_thumbnail_suffix, '.png'))
		file_base_name = "#{File.basename(Configuration.get(:fax_outgoing_file_prefix, 'fax_out_'))}#{SecureRandom.hex(10)}"
		raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{file_base_name}#{raw_file_suffix}")
		thumbnail_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{file_base_name}#{thumbnail_suffix}")
		
		if (File.exist?(raw_file))
			errors.add( :base, I18n.t(:file_exists))
			return false
		end
		
		#create fax g3 file
		system "gs -q -r#{resolution} -g#{page_size} -dNOPAUSE -dBATCH -dSAFER -sDEVICE=tiffg3 -sOutputFile=\"#{raw_file}\" -- \"#{input_file}\""
		if (! File.exist?(raw_file))
			system "convert -quiet -density #{resolution} -resize #{page_size}\! -monochrome -compress Fax \"#{input_file}\" \"#{raw_file}\""
		end
		
		thumbnail_resolution = "#{Configuration.get(:fax_thumbnail_horizontal_resolution, 21, Integer)}x#{Configuration.get(:fax_thumbnail_vertical_resolution, 31, Integer)}"
		thumbnail_size = "#{Configuration.get(:fax_thumbnail_width, 210, Integer)}x#{Configuration.get(:fax_thumbnail_height, 310, Integer)}"
		
		#create fax png thumbnail
		if (File.exist?(raw_file))
			system "convert -quiet -flatten -resize #{thumbnail_size}\! \"#{raw_file}\" \"#{thumbnail_file}\""
		end
		
		#check if all fallbacks failed and the files are still not present
		if (! File.exist?(raw_file))
			errors.add( :base, I18n.t(:fax_document_not_created))
		end
		if (! File.exist?(thumbnail_file))
			errors.add( :base, I18n.t(:fax_thumbnail_not_created))
		end
		
		self.raw_file = file_base_name
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
		return XmlRpc.send_fax(destination, domain, raw_file)
	end
	
	def delete_fax_files(raw_file)
		thumbnail_suffix = File.basename(Configuration.get(:fax_thumbnail_suffix, '.png'))
		thumbnail_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{raw_file}#{thumbnail_suffix}")
		begin
			File.unlink( thumbnail_file )
		rescue
		end
		raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
		raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{raw_file}#{raw_file_suffix}")
		begin
			File.unlink( raw_file )
		rescue
		end
	end
end
