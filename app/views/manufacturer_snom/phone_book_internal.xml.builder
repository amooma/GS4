xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title('Internal Phone Book')
	@sip_accounts.each { |sip_account|
		exts = sip_account.extensions.accessible_by( current_ability, :index ).where(:active => true)
		if exts.count > 0 
			xml.tag!( 'DirectoryEntry' ) {
				extension = exts.first.extension
				xml.Name("#{sip_account.caller_name}: #{extension}")
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
