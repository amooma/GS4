xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneInput {
	xml.Title(t(:call_forwarding_offline))
	xml.Prompt(t(:destination))
	xml.URL("#{@xml_menu_url}/call_forwarding_save.xml")
	xml.InputItem {
		xml.DisplayName(t(:destination))
		xml.QueryStringParam('case=offline&destination')
		xml.DefaultValue("#{@offline_destination}")
		xml.InputFlags('t')
	}
}
