xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title(t(:phone_book_internal))
	@sip_accounts.each { |sip_account|
		exts = sip_account.extensions.where(:active => true)
		if exts.count > 0 
			xml.tag!( 'DirectoryEntry' ) {
				extension = exts.first.extension
				lastname, firstname = sip_account.caller_name.split(/, *| /, 2)
				xml.Name(t(:xml_menu_phone_book_entry, :lastname => lastname, :firstname => firstname, :number => extension))
				xml.Telephone( extension )
			}
		end
	}
}


# Local Variables:
# mode: ruby
# End:
