xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title(t(:phone_book_internal))
	@sip_accounts.each { |sip_account|
		exts = sip_account.extensions.accessible_by( current_ability, :index ).where(:active => true)
		if exts.count > 0 
			xml.tag!( 'DirectoryEntry' ) {
				extension = exts.first.extension
				xml.Name(t(:xml_menu_phone_book_entry, :caller_name => sip_account.caller_name, :extension => extension))
				xml.Telephone( extension )
			}
		end
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
