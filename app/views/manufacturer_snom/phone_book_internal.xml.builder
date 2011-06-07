xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

#FIXME Isn't this the same thing as app/views/phone_book_internal_users/index.xml.builder ? Import fixes from there! (=> pko)

xml.SnomIPPhoneDirectory {
	xml.Title('Phone Book')
	@sip_accounts.each { |sip_account|
		if sip_account.extensions.count > 0 
			extension = sip_account.extensions.where(:active => true).first.extension
			xml.tag!('DirectoryEntry') {
				xml.Name("#{sip_account.caller_name}: #{extension}")
				xml.Telephone(extension)
			}
		end
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
