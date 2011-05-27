xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

if (@query_timeout && @destination.blank?)
	xml.SnomIPPhoneText {
	xml.Title('Call Forwarding on No Answer')
	xml.Text('Disable Call Forwarding')
	xml.fetch("#{@provisioning_server_url}/call_forwarding/save.xml?noanswer_destination=", :mil => '1')

	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@provisioning_server_url}/xml_menu.xml")
	}
}
else 
	xml.SnomIPPhoneInput {
		xml.Title('Call Forwarding on No Answer')
		xml.Prompt('Destination:')
		
		if (@query_timeout)
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
				xml.QueryStringParam('query_timeout=1&noanswer_destination')
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
end


# Local Variables:
# mode: ruby
# End:
