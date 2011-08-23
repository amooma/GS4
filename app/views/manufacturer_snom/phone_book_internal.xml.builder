xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	if (@keys.blank?)
		xml.Title(t(:phone_book_internal))
	else
		xml.Title(@keys)
	end
	@internal_contacts.each { |entry|
		xml.tag!( 'DirectoryEntry' ) {
			xml.Name(t(:xml_menu_phone_book_entry, :lastname => entry[:lastname], :firstname => entry[:firstname], :number => entry[:number]))
			xml.Telephone( entry[:number] )
		}
	}
	for key_id in (0..9)  
		xml.SoftKeyItem {
			xml.Name(key_id)
			xml.URL("#{@xml_menu_url}/phone_book_internal.xml?keys=#{@keys}#{key_id}")
		}
	end
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml?keys=#{@keys[0..-2]}")
	}
	xml.SoftKeyItem {
		xml.Name('#')
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml?keys=")
	}
}
