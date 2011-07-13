xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title(t(:global_contacts))
	@global_contacts.each { |entry|
		if (!entry.phone_business.blank?)
			xml.tag!( 'DirectoryEntry' ) {
				xml.Name(t(:xml_menu_phone_book_entry, :lastname => entry.lastname, :firstname => entry.firstname, :number => entry.phone_business))
				xml.Telephone( entry.phone_business )
			}
		end
		if (!entry.phone_private.blank?)
			xml.tag!( 'DirectoryEntry' ) {
				xml.Name(t(:xml_menu_phone_book_entry, :lastname => entry.lastname, :firstname => entry.firstname, :number => entry.phone_private))
				xml.Telephone( entry.phone_private )
			}
		end
		if (!entry.phone_mobile.blank?)
			xml.tag!( 'DirectoryEntry' ) {
				xml.Name(t(:xml_menu_phone_book_entry, :lastname => entry.lastname, :firstname => entry.firstname, :number => entry.phone_mobile))
				xml.Telephone( entry.phone_mobile )
			}
		end
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}