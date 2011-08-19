xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title(t(:call_forwarding_for, :name => @sip_account_name))
	
	xml.MenuItem {
		xml.Name(t(:call_forwarding_always_destination, :destination => @always_destination))
		xml.URL("#{@xml_menu_url}/call_forwarding_always.xml")
	}
	xml.MenuItem {
		xml.Name(t(:call_forwarding_assistant_destination, :destination => @assistant_destination))
		xml.URL("#{@xml_menu_url}/call_forwarding_assistant.xml")
	}
	xml.MenuItem {
		xml.Name(t(:call_forwarding_busy_destination, :destination => @busy_destination))
		xml.URL("#{@xml_menu_url}/call_forwarding_busy.xml")
	}
	xml.MenuItem {
		xml.Name(t(:call_forwarding_noanswer_destination, :destination => @noanswer_destination))
		xml.URL("#{@xml_menu_url}/call_forwarding_noanswer.xml")
	}
	xml.MenuItem {
		xml.Name(t(:call_forwarding_offline_destination, :destination => @offline_destination))
		xml.URL("#{@xml_menu_url}/call_forwarding_offline.xml")
	}
}
