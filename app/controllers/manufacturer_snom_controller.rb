class ManufacturerSnomController < ApplicationController
	
	def show
		mac_address = params[:mac_address].upcase.gsub(/[^A-F0-9]/,'')
		@phone = Phone.where(:mac_address => mac_address).first
		@my_local_ip = local_ip
		
		##### Codec mapping {
		# map from Codec names as in seeds.rb to their respective name
		# (or rather: number) on Snom:
		@codec_mapping_snom = {
			'ulaw' =>  0,  # G.711 u-law
			'alaw' =>  8,  # G.711 a-law
			'gsm'  =>  3,  # GSM
			'g722' =>  9,  # G.722
			'g726' =>  2,  # G.726-32  Assume that "g726" in the codecs table means G.726-32.
			'g729' => 18,  # G.729a
			'g723' =>  4,  # G.723.1  Assume that "g723" in the codecs table does not mean G.723 but G.723.1.
		}
		##### Codec mapping }
		
		if (! @phone.nil?)
			if (! request.env['HTTP_USER_AGENT'].index("snom").nil?)
				@phone.provisioning_log_entries.create(:succeeded => true, :memo => "Phone got config")
				@phone.update_attributes(:ip_address => request.remote_ip)
			end
			respond_to { |format|
				format.xml 
			}
		else
			#respond_to { |format|
			#	format.html
			#}
			render(
				:status => 404,
				:layout => false,
				:content_type => 'text/plain',
				:text => "<!-- Phone #{mac_address.inspect} not found. -->",
			)
		end
	end
	
	def index
		mfc = Manufacturer.where(:ieee_name => "SNOM Technology AG").first
		@phones = mfc ? mfc.phones : []
		
		respond_to { |format|
			format.html # index.html.erb
			format.xml  { render :xml => @phones }
		}
	end
	
end
