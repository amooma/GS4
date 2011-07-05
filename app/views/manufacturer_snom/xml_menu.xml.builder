xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	if (! @sip_account_name.blank?)
		xml.Title(t(:xml_menu_title, :sip_account => @sip_account_name))
	else
		xml.Title(t(:application_name))
	end

	xml.MenuItem {
		xml.Name(t(:phone_book_internal))
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml")
	}
	
	if (! @sip_account_name.blank?)
		xml.MenuItem {
			xml.Name(t(:call_log))
			xml.URL("#{@xml_menu_url}/call_log.xml")
		}
		xml.MenuItem {
			xml.Name(t(:call_forward))
			xml.URL("#{@xml_menu_url}/call_forwarding.xml")
		}
	end

	if (@sip_accounts_count > 1)
		xml.MenuItem {
			xml.Name(t(:select_sip_account))
			xml.URL("#{@xml_menu_url}/sip_accounts.xml")
		}
	end
	xml.SoftKeyItem {
		xml.Name('F1')
		xml.Label(t(:phone_book_internal_key_label_short))
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml")
	}
	xml.SoftKeyItem {
		xml.Name('F2')
		xml.Label(t(:call_forwarding_key_label_short))
		xml.URL("#{@xml_menu_url}/call_forwarding.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
