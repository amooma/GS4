xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title('Call Forwarding to assistant')
	xml.Prompt('Destination:')
	xml.URL("#{@provisioning_server_url}/call_forwarding/save.xml")
	xml.InputItem {
		xml.DisplayName("Destination:")
		xml.QueryStringParam('assistant_destination')
		xml.DefaultValue("#{@assistant_destination}")
		xml.InputFlags('t')
	}
	
	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
