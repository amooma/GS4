xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title('Select SIP Account')
	@sip_accounts.each { |sip_account|
		xml.MenuItem {
			xml.Name("#{sip_account.caller_name} (#{sip_account.auth_name})")
			xml.URL("#{@xml_menu_url}/#{sip_account.id}/xml_menu.xml")
		}
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
