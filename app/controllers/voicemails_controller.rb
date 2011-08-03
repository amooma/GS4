class VoicemailsController < ApplicationController
	 
	before_filter :authenticate_user!

	load_and_authorize_resource
  
	before_filter { |controller|        
		require 'xml_rpc'                          
	}
	
	def index
		sip_accounts = current_user.sip_accounts.all
		@voicemails = []
		if sip_accounts
			sip_accounts.each do |sip_account|
				voicemails_account = XmlRpc.voicemails_get(sip_account.auth_name, sip_account.sip_server.host)
				if voicemails_account == false
					flash[:alert] = t(:error_retrieving_voicemail_list, :name => sip_account.to_display)
				elsif voicemails_account
					@voicemails = @voicemails.concat(voicemails_account)
				end
			end
		end
		if @voicemails
			@voicemails.each do |voicemail_message|
				 voicemail_details = XmlRpc.voicemail_get_details(voicemail_message['username'], voicemail_message['domain'], voicemail_message['uuid'])
				 if (voicemail_details && voicemail_details.key?('VM-Message-Duration'))
				 	voicemail_message['duration'] =  voicemail_details['VM-Message-Duration']
				 else
					 flash[:alert] =  t(:error_retrieving_voicemail, :name => voicemail_message['uuid'])
					 voicemail_message['duration'] = 0
				 end
			end	
		end
		
		respond_to do |format|
			format.html
			format.xml { render :xml => @voicemails }
		end
	end
	
	def show
		if (params[:id] && params[:account])
			uuid = params[:id]
			sip_account = current_user.sip_accounts.where(:auth_name => params[:account]).first
		end
		
		if sip_account
			@auth_name = sip_account.auth_name
			@sip_account_display = sip_account.to_display
			@voicemail = XmlRpc.voicemail_get_details(@auth_name, sip_account.sip_server.host, uuid)
			if @voicemail == false
				flash[:alert] = t(:error_retrieving_voicemail, :name => uuid)
			end
		end

		respond_to do |format|
			format.html
			format.xml  { render :xml => @voicemail }
			format.wav { 
				if File.exist?(@voicemail['VM-Message-File-Path'])
					send_file @voicemail['VM-Message-File-Path'], :type => "audio/x-wav", 
					:filename => File.basename(@voicemail['VM-Message-File-Path'])
				else
					render(
						:status => 404,
						:layout => false,
						:content_type => 'text/plain',
						:text => "<!-- File not found. -->",
					)  
				end
			}
		end
	end

	def destroy
		if (params[:id] && params[:account])
			uuid = params[:id]
			sip_account = current_user.sip_accounts.where(:auth_name => params[:account]).first
		end
		
		if sip_account
			@auth_name = sip_account.auth_name
			@voicemail = XmlRpc.voicemail_delete(@auth_name, sip_account.sip_server.host, uuid)
		end
		
		respond_to do |format|
		format.html { redirect_to(voicemails_url) }
		format.xml  { head :ok }
		end
	end
end
