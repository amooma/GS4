xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title('Call Forwarding on No Answer')
	xml.Prompt('Destination:')
	
	if (@query_timeout)
		xml.URL("#{@xml_menu_url}/call_forwarding_save.xml")
		xml.InputItem {
			xml.DisplayName("Timeout:")
			xml.QueryStringParam("case=noanswer&destination=#{@cfwd_destination}&timeout")
			xml.DefaultValue(@noanswer_timeout)
			xml.InputFlags('n')
		}
	else
		xml.URL("#{@xml_menu_url}/call_forwarding_noanswer.xml")
		xml.InputItem {
			xml.DisplayName("Destination:")
			xml.QueryStringParam('case=noanswer&query_timeout=1&destination')
			xml.DefaultValue(@noanswer_destination)
			xml.InputFlags('t')
		}
	end
	xml.SoftKeyItem {
		xml.Label('Exit')
		xml.Name('F2')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}



# Local Variables:
# mode: ruby
# End:
