module ApplicationHelper
	
	# Define the top navigation menu items
	#
	def top_menu_items
		menu = []
		
		# Note: Sub-menus can be { :text => nil, :url => nil } to generate a horizontal separator.
		
		if user_signed_in?
			case current_user.role
				
				when "admin"
					menu <<
						{ :text => t('menu.home')        , :url => root_path }
					menu <<
						{ :text => t(:accounts), :sub => [
							{ :text => t(:phones)        , :url => phones_path },
							{ :text => t(:users)         , :url => admin_users_path },
							{ :text => t(:sip_accounts)  , :url => sip_accounts_path },
							{ :text => nil               , :url => nil },
							{ :text => t(:callforwards)  , :url => call_forwards_path },
							{ :text => nil               , :url => nil },
							{ :text => t(:global_contacts)   , :url => global_contacts_path },
							{ :text => nil               , :url => nil },
							{ :text => t(:ldap_import_sessions)   , :url => new_ldap_import_session_path },
						]}
					menu <<
						{ :text => t(:extensions)    , :url => extensions_path }
					menu <<
						{ :text => t(:media_services), :sub => [
							{ :text => t(:queues)        , :url => call_queues_path },
							{ :text => t(:conferences)   , :url => conferences_path },
						]}
					menu <<
						{ :text => t('menu.routing'), :sub => [
							{ :text => t('menu.sip_gateways'), :url => sip_gateways_path },
							{ :text => t('menu.dp_routes')   , :url => dialplan_routes_path },
							{ :text => t('menu.dp_patterns') , :url => dialplan_patterns_path },
						]}
					
					if is_appliance
					menu <<
						{ :text => t('menu.maintenance'), :sub => [
							{ :text => t(:mail_configuration), :url => admin_mail_configuration_path },
							{ :text => t(:network_setting)   , :url => network_settings_path },
							{ :text => t(:shutdown)          , :url => admin_confirm_shutdown_path },
							{ :text => t(:reboot_system)     , :url => admin_confirm_reboot_path },
							{ :text => t(:backup)            , :url => backups_path },
						]}
					else
					menu <<
						{ :text => t(:servers), :sub => [
							{ :text => t(:sip_domains)       , :url => sip_servers_path },
							{ :text => t(:sip_proxies)       , :url => sip_proxies_path },
							{ :text => t(:voicemail_servers) , :url => voicemail_servers_path },
							{ :text => t(:nodes)             , :url => nodes_path },
							{ :text => t(:mail_configuration), :url => admin_mail_configuration_path },
						]}
					end
					
					menu <<
						{ :text => t(:help)          , :url => admin_help_path }
					
				when "cdr"
					menu <<
						{ :text => t(:cdrs)     , :url => cdrs_path }
					
				when "user"
					menu <<
						{ :text => t(:callforwards)  , :url => call_forwards_path }
					menu <<
						{ :text => t(:call_logs)     , :url => call_logs_path }
					menu <<
						{ :text => t(:Contacts), :sub => [
							{ :text => t(:personal_contacts) , :url => personal_contacts_path },
							{ :text => t(:global_contacts)   , :url => global_contacts_path },
						]}
					menu <<
						{ :text => t(:voicemails)    , :url => voicemails_path }
					menu <<
						{ :text => t(:fax_documents) , :url => fax_documents_path }
					menu <<
						{ :text => t(:conferences)   , :url => conferences_path }
					menu <<
						{ :text => t(:Settings), :sub => [
							{ :text => t(:voicemail_pin_change), :url => pin_change_path },
						]}
					
			end
		elsif ! current_page?(:controller => 'admin/setup', :action => 'new')
			menu <<
				{ :text => t(:sign_in)       , :url => new_user_session_path }
		else
			menu <<
				{}
		end
		return menu
	end
	
	def page_title( page_title )
		content_for(:page_title) { page_title }
	end
	
	def is_appliance
		return Cfg.bool( :is_appliance, false )
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

