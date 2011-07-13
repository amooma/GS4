xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title(t(:phone_books))
	
	xml.MenuItem {
		xml.Name(t(:phone_book_internal))
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml")
	}

	if (@global_contacts && @global_contacts.count > 0)
		xml.MenuItem {
			xml.Name(t(:global_contacts))
			xml.URL("#{@xml_menu_url}/global_contacts.xml")
		}
	end

	if (@personal_contacts && @personal_contacts.count > 0)
		xml.MenuItem {
			xml.Name(t(:personal_contacts))
			xml.URL("#{@xml_menu_url}/personal_contacts.xml")
		}
	end
	
	xml.SoftKeyItem {
		xml.Name('F1')
		xml.Label(t(:phone_book_internal_key_label_short))
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
