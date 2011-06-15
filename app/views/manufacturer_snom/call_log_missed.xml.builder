xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title("Missed Calls")
	@call_logs_missed.each { |call_entry|
			if (call_entry.created_at < Time.now.advance(:hours => -12))
				date_formatted = call_entry.created_at.localtime.strftime("%m/%d/%y")
			else
				date_formatted = call_entry.created_at.localtime.strftime("%H:%M")
			end
			source_name = call_entry.source_name
			source_number = call_entry.source
			if (source_number.blank? && source_name.blank?)
				source_name = 'anonymous'
			end
			xml.tag!( 'DirectoryEntry' ) {
				xml.Name("#{date_formatted} #{source_name}:#{source_number}")
				xml.Telephone( call_entry.source )
			}
	}
	xml.SoftKeyItem {
		xml.Name('*')
		xml.URL("#{@xml_menu_url}/xml_menu.xml")
	}
}