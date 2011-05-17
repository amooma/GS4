xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title('Phone Book')
	@sip_accounts.each { |sip_account|
		if sip_account.extensions.count > 0 
			xml.tag!('DirectoryEntry') {
				xml.Name(sip_account.caller_name)
				xml.Telephone(sip_account.extensions.where(:active => true).first.extension)
			}
		end
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}