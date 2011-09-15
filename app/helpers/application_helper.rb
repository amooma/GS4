module ApplicationHelper
	
	# Define the top navigation menu items
	#
	def top_menu_items
		menu_items = []
		if user_signed_in?
			case current_user.role
				
				when "admin"
					menu_items = [
						{ :text => t('menu.home')        , :url => root_path },
						
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
						]},
						
						{ :text => t(:servers), :sub => [
							{ :text => t(:sip_domains)       , :url => sip_servers_path },
							{ :text => t(:sip_proxies)       , :url => sip_proxies_path },
							{ :text => t(:voicemail_servers) , :url => voicemail_servers_path },
							{ :text => t(:nodes)             , :url => nodes_path },
							{ :text => nil                   , :url => nil },
							{ :text => t('menu.sip_gateways'), :url => sip_gateways_path },
							{ :text => nil                   , :url => nil },
							{ :text => t('menu.dp_patterns') , :url => dialplan_patterns_path },
							{ :text => t('menu.dp_routes')   , :url => dialplan_routes_path },
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
						{ :text => t(:fax_documents) , :url => fax_documents_path },
						{ :text => t(:conferences)   , :url => conferences_path },
						
						{ :text => t(:Settings), :sub => [
							{ :text => t(:voicemail_pin_change), :url => pin_change_path },
						]},
					]
			end
		elsif ! current_page?(:controller => 'admin/setup', :action => 'new')
			menu_items = [
				{ :text => t(:sign_in)       , :url => new_user_session_path },
			]
		else
			menu_items = [
				{},
			] 
		end
		return menu_items
	end
	
	def page_title( page_title )
		content_for(:page_title) { page_title }
	end
	
	# This version of +link_to+ makes sure that in the local kiosk
	# mode no external links are displayed. The kiosk doesn't
	# provide a back-button.
	#
	# The original file:
	# actionpack/lib/action_view/helpers/url_helper.rb, line 231
	#
	def link_to( *args, &block )
		if block_given?
			options      = args.first || {}
			html_options = args.second
			link_to( capture( &block ), options, html_options )
		else
			name         = args[0]
			options      = args[1] || {}
			html_options = args[2]
			
			html_options = convert_options_to_data_attributes( options, html_options )
			url = url_for( options )
			
			href = html_options['href']
			tag_options = tag_options( html_options )
			
			href_attr = "href=\"#{ERB::Util.html_escape( url )}\"" unless href
			
			############################################ CUSTOM {
			if request.env['REMOTE_ADDR'] == '127.0.0.1'
				# The request came from a local browser (kiosk browser).
				if ((url.to_s[0] != '/') \
				&&  (url.to_s[0] != '#') \
				)
					# +url+ is neither an absolute path nor a fragment.
					# It's probably a fully qualified URL, including a host.
					# (It could be a relative path, but that doesn't
					# happen in our application.)
					# We don't want fully qualified URLs to be
					# rendered as a link.
					
					if (name || url) == url
						# Link text equals +url+.
						return "#{ERB::Util.html_escape( name || url )}".html_safe
					else
						# Link text is different from the +url+.
						return "#{ERB::Util.html_escape( name || url )} (#{ERB::Util.html_escape( url )})".html_safe
					end
				end
			end
			# If we came here it's all good. Either the request
			# came from a remote browser or the +uri+ doesn't
			# point to a different host. We can use the return
			# value of the original +link_to+ method.
			############################################ CUSTOM }
			
			"<a #{href_attr}#{tag_options}>#{ERB::Util.html_escape( name || url )}</a>".html_safe
		end
	end
	
end

