class NetworkSetting < ActiveRecord::Base
  
  before_validation( :on => :create ) {
    if NetworkSetting.count > 0
      errors.add( :network_setting, I18n.t(:allready_configured))
    end
  }
  
  before_validation( :on => :update ) {
    if ip_address != ip_address_was 
      errors.add( :ip_address, I18n.t(:can_not_be_changed))
    end
    if dhcp_client != dhcp_client_was
      errors.add( :dhcp_client, I18n.t(:can_not_be_changed))
    end
  }
  
  #validate :validate_settings
  
  validates_inclusion_of :interface, :in => ['eth0']  #OPTIMIZE Interface name is system-specific.
  
  
  network_interfaces = "
  auto lo
  iface lo inet loopback
  "
  
  after_save {
    if Configuration.get( :is_appliance, false, Configuration::Boolean )
      if self.dhcp_client == false
        network_interfaces = "
        #{network_interfaces}
        
        auto #{interface}
        iface #{interface} inet static
        address #{ip_address}
        netmask #{netmask}
        #{"gateway #{gateway}" if ! gateway.blank?}    
        "
      else
        network_interfaces = "
        #{network_interfaces}
        iface #{interface}
        iface #{interface} inet dhcp
        "
      end
      
      if ! name_server.empty? && ! dhcp_client
        resolv_conf= "nameserver #{name_server}"
        write_files('/tmp/resolv', resolv_conf)
      else
        resolv_conf = ""
      end
      
      if start_dhcp_server
        dnsmasq_conf ="
          dhcp-range=#{dhcp_range_start},#{dhcp_range_end},12h
          dhcp-option=66,http://#{ip_address}:80
          dhcp-option=67,settings
        "
      else
        dnsmasq_conf = ""
      end
      
      #OPTIMIZE File paths are system-specific. E.g. limit this to Debian.
      file_path_etc     = "/tmp/"
      file_path_network = "/tmp/"
      if RAILS_ENV == "production"
        file_path_etc     = "/etc/"
        file_path_network = "/etc/network/"
      end
      
      write_files("#{file_path_etc}dnsmasq.conf", dnsmasq_conf)
      write_files("#{file_path_etc}resolv.conf", resolv_conf)
      write_files("#{file_path_network}interfaces", network_interfaces)
    end
  }
  
  after_save(:on => :create) {
    if ! dhcp_client
      servers = [ 'SipServer', 'SipProxy', 'VoicemailServer' ]
      servers.each do |server|
        if server.constantize.where(:is_local => true).empty?
          server.constantize.create(:host => ip_address, :is_local => true)
        end
      end
    end
  }
  
  def validate_settings
    if dhcp_client 
      if ! ip_address.empty?
        errors.add( :ip_address, I18n.t(:must_not_be_set))
      end
      if ! netmask.empty?
        errors.add( :netmask, I18n.t(:must_not_be_set))
      end
      if ! gateway.empty?
        errors.add( :gateway, I18n.t(:must_not_be_set))
      end
      if start_dhcp_server
        errors.add( :start_dhcp_server, I18n.t(:must_not_be_set))
      end
      if ! name_server.empty?
        errors.add( :name_server, I18n.t(:must_not_be_set))
      end
    else
      ActiveRecord::Base.validate_hostname_or_ip :ip_address
      ActiveRecord::Base.validate_hostname_or_ip :gateway, :allow_nil => true
      ActiveRecord::Base.validate_hostname_or_ip :name_server, :allow_nil => true
      ActiveRecord::Base.validate_netmask :netmask
    end
    
    if start_dhcp_server
      ActiveRecord::Base.validate_hostname_or_ip :dhcp_range_start
      ActiveRecord::Base.validate_hostname_or_ip :dhcp_range_end
    end
  end
  
  private
  
  def write_files( filename, output )
    File.open(filename, 'w') {|f| f.write(output) }
  end
  
end
