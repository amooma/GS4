class RemoveManagementPortAndManagementHostFromSipProxy < ActiveRecord::Migration
  def self.up
    remove_column :sip_proxies, :management_port
    remove_column :sip_proxies, :management_host
  end

  def self.down
    add_column :sip_proxies, :management_host, :string
    add_column :sip_proxies, :management_port, :integer
  end
end
