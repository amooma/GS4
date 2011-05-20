xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title('Call Forwarding on No Answer')
	xml.Prompt('Destination:')
	
	if (! @destination.blank?)
	xml.URL("#{@provisioning_server_url}/call_forwarding/save.xml")
		xml.InputItem {
			xml.DisplayName("Timeout:")
			xml.QueryStringParam("noanswer_destination=#{@destination}&noanswer_timeout")
			xml.DefaultValue(@noanswer_timeout)
			xml.InputFlags('n')
		}
	else
	xml.URL("#{@provisioning_server_url}/call_forwarding/noanswer.xml")
		xml.InputItem {
			xml.DisplayName("Destination:")
			xml.QueryStringParam('noanswer_destination')
			xml.DefaultValue(@noanswer_destination)
			xml.InputFlags('t')
		}
	end
	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
