xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title('Call Forwarding on Offline')
	xml.Prompt('Destination:')
	xml.URL("#{@provisioning_server_url}/call_forwarding/save.xml")
	xml.InputItem {
		xml.DisplayName("Destination:")
		xml.QueryStringParam('offline_destination')
		xml.DefaultValue("#{@offline_destination}")
		xml.InputFlags('t')
	}

	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}