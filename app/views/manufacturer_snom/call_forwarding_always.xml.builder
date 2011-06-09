xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title('Unconditional Call Forwarding')
	xml.Prompt('Destination:')
	xml.URL("#{@provisioning_server_url}/call_forwarding/save.xml")
	xml.InputItem {
		xml.DisplayName("Destination:")
		xml.QueryStringParam('always_destination')
		xml.DefaultValue("#{@always_destination}")
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
