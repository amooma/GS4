class FaxDocument < ActiveRecord::Base
	
	belongs_to :user
	
	validates_presence_of :raw_file
	validates_presence_of :file
	
	before_validation( :on => :create ) {
		if (FaxDocument.where(:user_id => self.user_id).count >= Configuration.get(:fax_max_files, 2048, Integer))
			errors.add( :base, I18n.t(:fax_document_too_many, :count => Configuration.get(:fax_max_files)) )
		else
			if (! self.raw_file)
				self.to_raw()
			end
			if (self.raw_file)
				raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
				raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{raw_file_suffix}")
				if (! File.exists?(raw_file))
					errors.add( :base, I18n.t(:fax_document_not_found))
				end
			else
				errors.add( :base, I18n.t(:fax_document_not_created))
			end
		end
	}
	
	before_destroy {
		delete_fax_files(self.raw_file)
	}
	
	def upload=(file_data)
		@upload = file_data
	end
		
	def transfer( destination )
		if ( sip_server = SipServer.where(:is_local => true).first )
			domain = sip_server.host
		else
			errors.add( :base, I18n.t(:fax_document_not_sent))
			return false
		end
		
		require 'xml_rpc'
		result = XmlRpc.send_fax(destination, domain, self.raw_file)
		if ! result
			errors.add( :base, I18n.t(:fax_document_not_sent))
			return false
		end
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
		pdf_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.pdf'))
		pdf_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{raw_file}#{pdf_file_suffix}")
		begin
			File.unlink( pdf_file )
		rescue
		end
	end
	
	def to_raw
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
		file_base_name = "#{File.basename(Configuration.get(:fax_outgoing_file_prefix, 'fax_out_'))}#{SecureRandom.hex(10)}"
		raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{file_base_name}#{raw_file_suffix}")		
		
		if (File.exist?(raw_file))
			errors.add( :base, I18n.t(:file_exists))
			return false
		end
		
		system "gs -q -r#{resolution} -g#{page_size} -dNOPAUSE -dBATCH -dSAFER -sDEVICE=tiffg3 -sOutputFile=\"#{raw_file}\" -- \"#{input_file}\""
		
		self.raw_file = file_base_name
		self.file = original_filename
		return true
	end	
	
	def to_pdf
		raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
		raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{raw_file_suffix}")
		pdf_suffix = File.basename(Configuration.get(:fax_pdf_suffix, '.pdf'))
		pdf_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{pdf_suffix}")
		paper_size = Configuration.get(:fax_pdf_paper_size, 'a4', String).downcase
		paper_size = ['letter', 'legal', 'A4'].include?(paper_size) ?  paper_size : 'A4'
		system "tiff2pdf -o \"#{pdf_file}\" -p #{paper_size} -a \"#{self.source}\" -c Gemeinschaft4 -t \"#{self.title}\" \"#{raw_file}\""
		if (File.exists?(pdf_file))
			return pdf_file
		end
	end
	
	def to_thumbnail
		raw_file_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
		raw_file =  File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{raw_file_suffix}")
		thumbnail_suffix = File.basename(Configuration.get(:fax_thumbnail_suffix, '.png'))
		thumbnail_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{thumbnail_suffix}")
		thumbnail_size = "#{Configuration.get(:fax_thumbnail_width, 210, Integer)}x#{Configuration.get(:fax_thumbnail_height, 310, Integer)}"		
		system "convert -quiet -flatten -resize #{thumbnail_size}\! \"#{raw_file}\" \"#{thumbnail_file}\""
		if (File.exists?(thumbnail_file))
			return thumbnail_file
		end
	end
	
	def raw_file_path
		raw_suffix = File.basename(Configuration.get(:fax_file_suffix, '.tif'))
		raw_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{raw_suffix}")
		if (File.exists?(raw_file))
			return raw_file
		end
	end
	
	def thumbnail_file_path
		thumbnail_suffix = File.basename(Configuration.get(:fax_thumbnail_suffix, '.png'))
		thumbnail_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{thumbnail_suffix}")
		if (File.exists?(thumbnail_file))
			return thumbnail_file
		end
	end
	
	def pdf_file_path
		pdf_suffix = File.basename(Configuration.get(:fax_pdf_suffix, '.pdf'))
		pdf_file = File.expand_path("#{Configuration.get(:fax_files_directory)}/#{self.raw_file}#{pdf_suffix}")
		if (File.exists?(pdf_file))
			return pdf_file
		end
	end
end
