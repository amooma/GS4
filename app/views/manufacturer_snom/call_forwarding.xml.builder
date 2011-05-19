xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title('Call Forwarding')
	xml.MenuItem {
		xml.Name('Unconditional')
		xml.URL("#{@provisioning_server_url}/call_forwarding_always.xml")
	}
	xml.MenuItem {
		xml.Name('If busy')
		xml.URL("#{@provisioning_server_url}/call_forwarding_busy.xml")
	}
	xml.MenuItem {
		xml.Name('If not answered')
		xml.URL("#{@provisioning_server_url}/call_forwarding_noanswer.xml")
	}
	xml.MenuItem {
		xml.Name('If offline')
		xml.URL("#{@provisioning_server_url}/call_forwarding_offline.xml")
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
