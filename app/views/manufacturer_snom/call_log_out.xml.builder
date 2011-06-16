xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title("Placed Calls")
	@call_logs_out.each { |call_entry|
		if (call_entry.created_at < Time.now.advance(:hours => -12))
			date_formatted = call_entry.created_at.localtime.strftime("%m/%d/%y")
		else
			date_formatted = call_entry.created_at.localtime.strftime("%H:%M")
		end
		destination_name   = call_entry.destination_name
		destination_number = call_entry.destination
		xml.tag!( 'DirectoryEntry' ) {
			xml.Name("#{date_formatted} #{destination_name}:#{destination_number}")
			xml.Telephone( call_entry.destination )
		}
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}


# Local Variables:
# mode: ruby
# End:
