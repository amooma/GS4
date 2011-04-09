class AddManagementPortToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :management_port, :integer
  end

  def self.down
    remove_column :sip_proxies, :management_port
  end
end
