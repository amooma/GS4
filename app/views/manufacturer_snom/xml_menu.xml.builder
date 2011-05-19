xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title('Gemeinschaft 4')
	xml.MenuItem {
		xml.Name('Phone Book')
		xml.URL("#{@provisioning_server_url}/phone_book_internal.xml")
	}
	xml.MenuItem {
		xml.Name('Call Forwarding')
		xml.URL("#{@provisioning_server_url}/call_forwarding.xml")
	}
	xml.SoftKeyItem {
		xml.Name('F1')
		xml.Label('PB')
		xml.URL("#{@provisioning_server_url}/phone_book_internal.xml")
	}
	xml.SoftKeyItem {
		xml.Name('F2')
		xml.Label('CF')
		xml.URL("#{@provisioning_server_url}/call_forwarding.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
