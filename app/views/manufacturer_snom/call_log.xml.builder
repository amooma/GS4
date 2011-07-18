xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu {
	xml.Title(t(:call_log_for, :name => @sip_account_name))
	
	xml.MenuItem {
		xml.Name(t(:calls_placed_number, :calls => @call_logs_out))
		xml.URL("#{@xml_menu_url}/call_log_out.xml")
	}
	xml.MenuItem {
		xml.Name(t(:calls_missed_number, :calls => @call_logs_missed))
		xml.URL("#{@xml_menu_url}/call_log_missed.xml")
	}
	xml.MenuItem {
		xml.Name(t(:calls_answered_number, :calls => @call_logs_in))
		xml.URL("#{@xml_menu_url}/call_log_in.xml")
	}
	xml.MenuItem {
		xml.Name(t(:calls_forwarded_number, :calls => @call_logs_forwarded))
		xml.URL("#{@xml_menu_url}/call_log_forwarded.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
