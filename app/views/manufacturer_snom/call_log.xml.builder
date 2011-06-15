xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title("Call Log for #{@sip_account_name}")
	xml.MenuItem {
		xml.Name("Calls Missed: #{@call_logs_missed}")
		xml.URL("#{@xml_menu_url}/call_log_missed.xml")
	}
	xml.MenuItem {
		xml.Name("Calls Answered: #{@call_logs_in}")
		xml.URL("#{@xml_menu_url}/call_log_in.xml")
	}
	xml.MenuItem {
		xml.Name("Calls Placed: #{@call_logs_out}")
		xml.URL("#{@xml_menu_url}/call_log_out.xml")
	}
}

# Local Variables:
# mode: ruby
# End:
