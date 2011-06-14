namespace :network do
  desc "Displays available local networks"
  task :subnets do
    system_type_supported()
    ns = LocalNetworkScan.new()
    subnets = ns.subnets()
    puts "available local networks: #{subnets.join(', ')}"
  end

  desc "Displays hosts on local networks"
  task :hosts do
    system_type_supported()
    ns = LocalNetworkScan.new()
    subnets = ns.subnets()
    hosts = ns.hosts()
    hosts.each do |host|
      puts "#{host} - #{ns.arp(host)}"
    end
    puts "#{hosts.count()} hosts(s) found"
  end

  desc "Displays known VoIP phones"
  task :phones => :environment do
    system_type_supported()
    phones_count = 0
    ns = LocalNetworkScan.new()
    subnets = ns.subnets()
    hosts = ns.hosts()
    hosts.each do |host|
      mac_address = ns.arp(host)
      if (mac_address)
        phone_model = PhoneModel.find_by_mac_address(mac_address)
        if (phone_model != nil)
          puts "#{host} - #{mac_address} - #{phone_model.name}"
          phones_count = phones_count + 1
        end
      else
        puts "Could not retrieve MAC for IP #{host}"
      end
    end
    puts "#{phones_count} phone(s) found"
  end

  desc "Finds and adds new phones to database"
  task :addphones => :environment do
    system_type_supported()
    phones_count = 0
    ns = LocalNetworkScan.new()
    subnets = ns.subnets()
    hosts = ns.hosts()
    hosts.each do |host|
      mac_address = ns.arp(host)
      if (mac_address)
        phone_model = PhoneModel.find_by_mac_address(mac_address)
        if (phone_model != nil)
          new_phone = Phone.create(:mac_address => mac_address, :phone_model_id => phone_model.id, :ip_address => host)
          if (new_phone.save() == true)
            puts "added phone: #{host} - #{mac_address} - #{phone_model.name}"
            phones_count = phones_count + 1
          end
        end
      end
    end
    puts "#{phones_count} new phone(s) added" 
  end

  def system_type_supported()
    if (RUBY_PLATFORM.downcase.include?("linux"))
      return true
    elsif (RUBY_PLATFORM.downcase.include?("darwin"))
      abort("OSX not supported. Please install Debian Linux for better results.")
    elsif (RUBY_PLATFORM.downcase.include?("mswin"))
      abort("Windows OS not supported. Please install Debian Linux for better results.")
    end
      
    abort("Unsupported operating system")
  end

  class LocalNetworkScan
    IPNET_REGEXP=/\s{4}inet\s(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d) (?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\/\d{1,2}/x
    HOST_REGEXP=/((Nmap\sscan\sreport\sfor\s)|(Host\s))(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d) (?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}/x
    MAC_REGEXP=/^ [0-9A-F]{2} (?: [:\-]? [0-9A-F]{2} ){5} $/ix

    def initialize 
      @subnets = []
      @hosts = []
    end

    def subnets
      networks = []
      ip_addr = Thread.new { `ip addr` }
      interfaces =  ip_addr.value.split(/^\d: /)
      interfaces.each do |interface|
        link = false
        
        entries = interface.split(/\n/)
        entries.each do |entry|
          if (entry =~ /state UP/)
            link = true
          elsif (entry =~ /state DOWN/)
            break
          elsif (entry =~ /LOOPBACK/)
            break
          end
          if (entry =~ IPNET_REGEXP)
            output = entry[IPNET_REGEXP, 0].split(/\s{4}inet\s/x, 2)
            networks.push(output[1])
          end
        end
        end
      @subnets = networks
      return networks
    rescue => error
        abort("ERROR: retrieving local networks failed")
    end

    def hosts(subnets = nil)
      if (subnets.class == Array)
        subnets_str =  subnets.join(' ')
      else
        subnets_str =  @subnets.join(' ')
      end

      hosts = []

      if (subnets_str == '')
        return hosts
      end

      nmap = Thread.new { `nmap -n -sP #{subnets_str}` }
      nmap_hosts = nmap.value.split(/\n/)
      nmap_hosts.each do |nmap_host|
        if (nmap_host =~ HOST_REGEXP)
          host = nmap_host[HOST_REGEXP].split(/(Nmap scan report for |Host )/, 2)[2]
          hosts.push(host)
        end
      end
      @hosts = hosts
      return hosts
    
    rescue => error
      abort("ERROR: retrieving hosts failed")
    end

    def arp(ip_addr)
      if(FileTest.exist?('/etc/SuSE-release'))
        arp_binary = "/sbin/arp -an"
      else
        arp_binary = "/usr/sbin/arp -an"
      end

      arp = Thread.new { `#{arp_binary} #{ip_addr}` } 
      arp_entries = arp.value.split(/\n/)   
      arp_entries.each do |arp_entry|
        arp_entry_values = arp_entry.split()
        if (arp_entry_values[1] == "(#{ip_addr})") 
          if (arp_entry_values[3] =~ MAC_REGEXP)
            return arp_entry_values[3]
          end
        end
      end
      return nil
    rescue => error
      abort("ERROR: retrieving MAC failed")
    end

  end

end


# Local Variables:
# mode: ruby
# End:


