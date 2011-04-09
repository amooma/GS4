class RenameColumnHostPortToPortInSipProxies < ActiveRecord::Migration
  
  def self.up
    rename_column :sip_proxies, :host_port, :port
  end

  def self.down
    rename_column :sip_proxies, :port, :host_port
  end
  
end
