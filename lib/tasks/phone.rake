namespace :phone do
  desc "Reboot a phone specified by it's IP odr MAX address"
  task :reboot, :phone, :needs => :environment do |task_name, args|
    if (ip_address_valid(args[:phone]))
      phone = Phone.find_by_ip_address(args[:phone])
    elsif (mac_address_valid(args[:phone]))    
      phone = Phone.find_by_mac_address(args[:phone])
    else
      abort("ERROR: Malformed MAC or IP address: \"#{args[:phone]}\" ")
    end
    
    if (phone.class == Phone)
        success = phone.reboot()
    else
        abort("ERROR: No phone found with IP/MAC: \"#{args[:phone]}\"")
    end

    if (success == false) 
      abort("Reboot request failed: \"#{args[:phone]}\"")
    else
      puts "Reboot request successful: \"#{args[:phone]}\""
    end
  end

  def ip_address_valid(ip_address)
    if (ip_address =~ /^ (?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d) (?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3} $ /x)
      return true
    end
    return false
  end

  def mac_address_valid(mac_address)
    if (mac_address =~ /^ [0-9A-F]{2} (?: [:\-]? [0-9A-F]{2} ){5} $/ix)
      return true
    end
    return false
  end

end