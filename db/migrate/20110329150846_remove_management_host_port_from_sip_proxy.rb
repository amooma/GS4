class RemoveManagementHostPortFromSipProxy < ActiveRecord::Migration
  def self.up
    remove_column :sip_proxies, :management_host_port
  end

  def self.down
    add_column :sip_proxies, :management_host_port, :integer
  end
end
