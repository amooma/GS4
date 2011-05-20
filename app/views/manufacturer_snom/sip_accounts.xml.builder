xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title('Select Sip Account')
	@sip_accounts.each { |sip_account|
		xml.MenuItem {
			xml.Name("#{sip_account.auth_name} - #{sip_account.caller_name}")
			xml.URL("#{@provisioning_server_url}/#{sip_account.auth_name}/call_forwarding.xml")
		}
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
