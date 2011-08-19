xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title(t(:calls_placed_number, :calls => @call_logs_out.count))
	@call_logs_out.each { |call_entry|
		if (call_entry.created_at < Time.now.advance(:hours => -12))
			date_formatted = l(call_entry.created_at.localtime, :format => :call_log_old)
		else
			date_formatted = l(call_entry.created_at.localtime, :format => :call_log_recent)
		end
		destination_name   = call_entry.destination_name
		destination_number = call_entry.destination
		xml.tag!( 'DirectoryEntry' ) {
			xml.Name(t(:xml_menu_call_log_entry, :call_date => date_formatted, :name => destination_name, :number => destination_number))
			xml.Telephone( call_entry.destination )
		}
	}
}
