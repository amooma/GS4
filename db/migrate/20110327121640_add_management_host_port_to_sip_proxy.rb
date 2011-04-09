class AddManagementHostPortToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :management_host_port, :integer
  end

  def self.down
    remove_column :sip_proxies, :management_host_port
  end
end
