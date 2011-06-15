xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title('Call Forwarding on Offline')
	xml.Prompt('Destination:')
	xml.URL("#{@xml_menu_url}/call_forwarding_save.xml")
	xml.InputItem {
		xml.DisplayName("Destination:")
		xml.QueryStringParam('case=offline&destination')
		xml.DefaultValue("#{@offline_destination}")
		xml.InputFlags('t')
	}
	
	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
