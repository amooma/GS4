xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	if (! @sip_account_name.blank?)
		xml.Title("Gemeinschaft 4 - #{@sip_account_name}")
	else
		xml.Title('Gemeinschaft 4')
	end
	xml.MenuItem {
		xml.Name('Phone Book')
		xml.URL("#{@provisioning_server_url}/phone_book_internal.xml")
	}
	if (! @sip_account_name.blank?)
		xml.MenuItem {
			xml.Name('Call Forwarding')
			xml.URL("#{@provisioning_server_url}#{@sip_account_url}/call_forwarding.xml")
		}
	end
	if (@sip_accounts_count > 1)
		xml.MenuItem {
			xml.Name('Select SIP Account')
			xml.URL("#{@provisioning_server_url}#{@sip_account_url}/sip_accounts.xml")
		}
	end
	xml.SoftKeyItem {
		xml.Name('F1')
		xml.Label('PB')
		xml.URL("#{@provisioning_server_url}/phone_book_internal.xml")
	}
	xml.SoftKeyItem {
		xml.Name('F2')
		xml.Label('CF')
		xml.URL("#{@provisioning_server_url}#{@sip_account_url}/call_forwarding.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
