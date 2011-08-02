class CreateNetworkSettings < ActiveRecord::Migration
  def self.up
    create_table :network_settings do |t|
      t.string :ip_address
      t.string :netmask
      t.string :gateway
      t.string :name_server
      t.string :dhcp_range_start
      t.string :dhcp_range_end
      t.boolean :start_dhcp_server
      t.boolean :dhcp_client

      t.timestamps
    end
  end

  def self.down
    drop_table :network_settings
  end
end
