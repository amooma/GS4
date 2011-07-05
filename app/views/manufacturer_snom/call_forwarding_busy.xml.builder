xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title(t(:call_forwarding_busy))
	xml.Prompt(t(:destination))
	xml.URL("#{@xml_menu_url}/call_forwarding_save.xml")
	xml.InputItem {
		xml.DisplayName(t(:destination))
		xml.QueryStringParam('case=busy&destination')
		xml.DefaultValue("#{@busy_destination}")
		xml.InputFlags('t')
	}
	
	xml.SoftKeyItem {
		xml.Label(t(:exit))
		xml.Name('F2')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
