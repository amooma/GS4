xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneDirectory {
	xml.Title(t(:calls_forwarded_number, :calls => @call_logs_forwarded.count))
	@call_logs_forwarded.each_with_index { |call_entry, index|
		if (call_entry.forwarded_to.blank?)
			next
		end
		if (index > @max_entries)
			break
		end
		if (call_entry.created_at < Time.now.advance(:hours => -12))
			date_formatted = l(call_entry.created_at.localtime, :format => :call_log_old)
		else
			date_formatted = l(call_entry.created_at.localtime, :format => :call_log_recent)
		end
		source_name   = call_entry.source_name
		source_number = call_entry.source
		if (source_number.blank? && source_name.blank?)
			source_name = 'anonymous'
		end
		xml.tag!( 'DirectoryEntry' ) {
			xml.Name(t(:xml_menu_call_log_forwarded, :call_date => date_formatted, :name => source_name, :number => source_number, :forwarded => call_entry.forwarded_to))
			xml.Telephone( call_entry.source )
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
