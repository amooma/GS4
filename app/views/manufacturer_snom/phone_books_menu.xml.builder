xml.instruct!  # <?xml version="1.0" encoding="UTF-8"?>

xml.SnomIPPhoneMenu(:title => t(:phone_books)) {
	xml.MenuItem(:name => t(:phone_book_internal)) {
		xml.URL("#{@xml_menu_url}/phone_book_internal.xml")
	}
	xml.MenuItem(:name => t(:global_contacts)) {
		xml.URL("#{@xml_menu_url}/global_contacts.xml")
	}
	xml.MenuItem(:name => t(:personal_contacts)) {
		xml.URL("#{@xml_menu_url}/personal_contacts.xml")
	}
	xml.MenuItem(:name => t(:call_log)) {
		snom_sip_acct_idx = 0
		@phone.sip_accounts.each { |sip_account|
			snom_sip_acct_idx += 1
			xml.If(:condition => "$(current_line)==#{snom_sip_acct_idx}") {
				xml.URL("#{@xml_menu_url}/#{sip_account.id}/call_log.xml")
			}
		}
	}
}

