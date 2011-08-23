xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title(t(:call_forwarding_noanswer))
	if (@query_timeout)
		xml.Prompt(t(:call_forwarding_timeout))
		xml.URL("#{@xml_menu_url}/call_forwarding_save.xml")
		xml.InputItem {
			xml.DisplayName(t(:call_forwarding_timeout))
			xml.QueryStringParam("case=noanswer&destination=#{@cfwd_destination}&timeout")
			xml.DefaultValue(@noanswer_timeout)
			xml.InputFlags('n')
		}
	else
		xml.Prompt(t(:destination))
		xml.URL("#{@xml_menu_url}/call_forwarding_noanswer.xml")
		xml.InputItem {
			xml.DisplayName(t(:destination))
			xml.QueryStringParam('case=noanswer&query_timeout=1&destination')
			xml.DefaultValue(@noanswer_destination)
			xml.InputFlags('t')
		}
	end
}


# Local Variables:
# mode: ruby
# End:
