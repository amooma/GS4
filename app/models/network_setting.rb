class NetworkSetting < ActiveRecord::Base
  
  #OPTIMIZE Make netmask an integer instead of a string and use the prefix length instead of a dotted quad. Easier to handle (validate/store/convert) and works for both IPv4 and IPv6.
  
  before_validation( :on => :create ) {
    if NetworkSetting.count > 0
      errors.add( :base, I18n.t(:network_settings_already_configured))
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
  
  
  validates_inclusion_of [
    :ip_address,
    :netmask,
    :gateway,
    :dhcp_range_start,
    :dhcp_range_end,
    :name_server,
  ], :in => [ nil, '' ]    , :if => Proc.new { |me| me.dhcp_client },
    :message => "#{ I18n.t(:must_not_be_set) } (DHCP client)"
  
  validates_inclusion_of [
    :start_dhcp_server,
  ], :in => [ false ]      , :if => Proc.new { |me| me.dhcp_client },
    :message => "#{ I18n.t(:must_not_be_set) } (DHCP client)"
  
  
  validate_hostname_or_ip [
    :ip_address,
  ], :allow_blank => false , :if => Proc.new { |me| ! me.dhcp_client }
  
  validate_hostname_or_ip [
    :gateway,
    :name_server,
  ], :allow_blank => true  , :if => Proc.new { |me| ! me.dhcp_client }
  
  validate_netmask [
    :netmask,
  ], :allow_blank => false , :if => Proc.new { |me| ! me.dhcp_client }
  
  validate_hostname_or_ip [
    :dhcp_range_start,
    :dhcp_range_end,
  ], :allow_blank => false , :if => Proc.new { |me| me.start_dhcp_server }
  
  
  validates_inclusion_of :interface, :in => ['eth0']  #OPTIMIZE Interface name is system-specific.
  
  
  network_interfaces = "
  auto lo
  iface lo inet loopback
  "
  
  after_save {
    if Configuration.get( :is_appliance, false, Configuration::Boolean ); (
      # is_appliance => This is a Knoppix system.
      
      if self.dhcp_client == false
        network_interfaces_write = "
        #{network_interfaces}
        
        auto #{interface}
        iface #{interface} inet static
        address #{ip_address}
        netmask #{netmask}
        #{"gateway #{gateway}" if ! gateway.blank?}    
        "
      else
        network_interfaces_write = "
        #{network_interfaces}
        auto #{interface}
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
          dhcp-option=66,https://#{ip_address}:443
          dhcp-option=67,settings
        "
      else
        dnsmasq_conf = ""
      end
      
      file_path_etc     = "/tmp/"
      file_path_network = "/tmp/"
      if ::Rails.env.to_s == "production"
        file_path_etc     = "/etc/"
        file_path_network = "/etc/network/"
      end
      
      write_files("#{file_path_etc}dnsmasq.conf", dnsmasq_conf)
      write_files("#{file_path_etc}resolv.conf", resolv_conf)
      write_files("#{file_path_network}interfaces", network_interfaces_write)
      
    )end
  }
  
  after_save( :on => :create ) {
    if ! dhcp_client
      servers = [ 'SipServer', 'SipProxy', 'VoicemailServer' ]
      servers.each do |server|
        if server.constantize.where(:is_local => true).empty?
          server.constantize.create(:host => ip_address, :is_local => true)
        end
      end
    end
  }
  
  
  private
  
  def write_files( filename, output )
    File.open(filename, 'w') {|f| f.write(output) }
  end
  
end
