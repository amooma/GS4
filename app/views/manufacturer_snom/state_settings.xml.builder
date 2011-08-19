xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>
	
xml.SnomIPPhoneMenu(:title => t(:application_name)) {
	xml.Menu(:name => t(:phone_books)) {
		xml.MenuItem(:name => t(:phone_book_internal)) {
			xml.URL("#{@xml_menu_url}/phone_book_internal.xml")
		}
		xml.MenuItem(:name => t(:global_contacts)) {
			xml.URL("#{@xml_menu_url}/global_contacts.xml")
		}
		xml.MenuItem(:name => t(:personal_contacts)) {
			xml.URL("#{@xml_menu_url}/personal_contacts.xml")
		}
	}

	xml.MenuItem(:name => t(:call_log)) {
		snom_sip_acct_idx = 0
		@phone.sip_accounts.each { |sip_account|
			snom_sip_acct_idx += 1
			xml.If(:condition => "$(current_line)==#{snom_sip_acct_idx}") {
				xml.URL("#{@xml_menu_url}/#{sip_account.id}/call_log.xml")
			}
		}
	}
	xml.MenuItem(:name => t(:call_forward)) {
		snom_sip_acct_idx = 0
		@phone.sip_accounts.each { |sip_account|
			snom_sip_acct_idx += 1
			xml.If(:condition => "$(current_line)==#{snom_sip_acct_idx}") {
				xml.URL("#{@xml_menu_url}/#{sip_account.id}/call_forwarding.xml")
			}
		}		
	}
	xml.MenuItem(:name => t(:voicemail)) {
		snom_sip_acct_idx = 0
		@phone.sip_accounts.each { |sip_account|
			snom_sip_acct_idx += 1
			xml.If(:condition => "$(current_line)==#{snom_sip_acct_idx}") {
				xml.URL("#{@xml_menu_url}/#{sip_account.id}/call_forwarding_voicemail.xml")	
			}
		}	
	}
	
	xml.MenuItem(:name => t(:select_sip_account)) {
		xml.Action("active_line")
	}
	
	xml.Menu(:name => "$(lang:preferences_settings)") {
		xml.MenuItem(:name => "$(lang:menu_gen_ringtone)") {
			xml.Action("ringtone")
		}
		xml.Menu(:name => "$(lang:display_settings)") {
			xml.MenuItem(:name => "$(lang:use_backlight) $(lang:backlight_when_active)") {
				xml.Action("backlight_active")
			}
			xml.MenuItem(:name => "$(lang:use_backlight) $(lang:backlight_when_idle)") {
				xml.Action("backlight_idle")
			}
			xml.MenuItem(:name => "$(lang:menu_gen_contrast)") {
				xml.Action("contrast")
			}
			xml.MenuItem(:name => "$(lang:use_backlight)") {
				xml.Action("use_backlight")
			}
		}
		xml.MenuItem(:name => "$(lang:menu_equalizer)") {
			xml.Action("equalizer")
		}
	}
		
	xml.Menu(:name => "$(lang:maintenance_settings)") {
		xml.MenuItem(:name => "$(lang:system_information_menu)") {
			xml.Action("sysinfo")
		}
		xml.If(:condition => "!$(set:admin_mode)") {
			xml.MenuItem(:name => "$(lang:sel100_admin_mode)", :id => "mode") {
				xml.Action("admin_mode")
			}
		}
		xml.If(:condition => "$(set:admin_mode)") {
			xml.MenuItem(:name => "$(lang:sel100_user_mode)", :id => "mode") {
				xml.Action("user_mode")
			}
		}
		xml.MenuItem(:name => "$(lang:sel100_reboot)") {
			xml.Action("reboot")
		}
		xml.If(:condition => "$(set:admin_mode)") {
			xml.MenuItem(:name => "$(lang:reset_settings)") {
				xml.Action("reset_settings")
			}
		}
		xml.If(:condition => "$(update_available)") {
			xml.MenuItem(:name => "$(lang:update_header)") {
				xml.Action("software_update")
			}
		}
	}
}
