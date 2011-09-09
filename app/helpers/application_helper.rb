module ApplicationHelper
	
	# Define the top navigation menu items
	#
	def top_menu_items
		menu_items = []
		if user_signed_in?
			case current_user.role
				
				when "admin"
					menu_items = [
						{ :text => t(:admin)         , :url => admin_index_path },
						
						{ :text => t(:accounts), :sub => [
							{ :text => t(:users)         , :url => admin_users_path },
							{ :text => t(:sip_accounts)  , :url => sip_accounts_path },
							{ :text => t(:callforwards)  , :url => call_forwards_path },
							{ :text => t(:personal_contacts) , :url => personal_contacts_path },
							{ :text => t(:global_contacts)   , :url => global_contacts_path },
						]},
						
						{ :text => t(:phones)        , :url => phones_path },
						
						{ :text => t(:extensions)    , :url => extensions_path },
						
						{ :text => t(:media_services), :sub => [
							{ :text => t(:queues)        , :url => call_queues_path },
							{ :text => t(:conferences)   , :url => conferences_path },
							{ :text => t(:fax_documents) , :url => fax_documents_path },
							{ :text => t(:voicemails)    , :url => voicemails_path },
						]},
						
						{ :text => t(:servers), :sub => [
							{ :text => t(:sip_domains)       , :url => sip_servers_path },
							{ :text => t(:sip_proxies)       , :url => sip_proxies_path },
							{ :text => t(:voicemail_servers) , :url => voicemail_servers_path },
							{ :text => t(:nodes)             , :url => nodes_path },
							{ :text => t('menu.sip_gateways'), :url => sip_gateways_path },
						]},
						
						{ :text => t(:help)          , :url => admin_help_path },
					]
				
				when "cdr"
					menu_items = [
						{ :text => t(:call_logs)     , :url => call_logs_path },
					]
				
				when "user"
					menu_items = [
						{ :text => t(:callforwards)  , :url => call_forwards_path },
						
						{ :text => t(:call_logs)     , :url => call_logs_path },
						
						{ :text => t(:Contacts), :sub => [
							{ :text => t(:personal_contacts) , :url => personal_contacts_path },
							{ :text => t(:global_contacts)   , :url => global_contacts_path },
						]},
						
						{ :text => t(:voicemails)    , :url => voicemails_path },
						
						{ :text => t(:conferences)   , :url => conferences_path },
						
						{ :text => t(:Settings), :sub => [
							{ :text => t(:voicemail_pin_change), :url => pin_change_path },
						]},
					]
			end
		else
			menu_items = [
				{ :text => t(:sign_in)       , :url => new_user_session_path },
			]
		end
		return menu_items
	end
	
	def page_title( page_title )
		content_for(:page_title) { page_title }
	end
	
end

