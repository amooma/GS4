xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title(t(:voicemail))
	
	xml.MenuItem {
		if @always_destination == "-vbox-#{@sip_account.auth_name}"
			xml.Name(t(:call_forwarding_always_destination, :destination => t(:active)))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=always&destination=")
		else
			xml.Name(t(:call_forwarding_always_destination, :destination => ''))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=always&destination=-vbox-#{@sip_account.auth_name}")
		end
	}
	xml.MenuItem {
		if @busy_destination == "-vbox-#{@sip_account.auth_name}"
			xml.Name(t(:call_forwarding_busy_destination, :destination => t(:active)))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=busy&destination=")
		else
			xml.Name(t(:call_forwarding_busy_destination, :destination => ''))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=busy&destination=-vbox-#{@sip_account.auth_name}")
		end
	}
	xml.MenuItem {
		if @noanswer_destination == "-vbox-#{@sip_account.auth_name}"
			xml.Name(t(:call_forwarding_noanswer_destination, :destination => t(:active)))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=noanswer&destination=")
		else
			xml.Name(t(:call_forwarding_noanswer_destination, :destination => ''))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=noanswer&destination=-vbox-#{@sip_account.auth_name}")
		end
	}
	xml.MenuItem {
		if @offline_destination == "-vbox-#{@sip_account.auth_name}"
			xml.Name(t(:call_forwarding_offline_destination, :destination => t(:active)))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=offline&destination=")
		else
			xml.Name(t(:call_forwarding_offline_destination, :destination => ''))
			xml.URL("#{@xml_menu_url}/call_forwarding_save.xml?case=offline&destination=-vbox-#{@sip_account.auth_name}")
		end
	}
}

