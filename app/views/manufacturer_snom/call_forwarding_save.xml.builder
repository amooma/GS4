xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneText {
	xml.Title("#{@title}")
	xml.Text("#{@message}")
	
	xml.fetch("#{@xml_menu_url}/call_forwarding.xml", :mil => '3000') 
}
