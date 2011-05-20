xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneText {
	xml.Title("#{@title}")
	xml.Text("#{@message}")

	xml.fetch("#{@provisioning_server_url}/call_forwarding.xml", :mil => '3000') 

	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
