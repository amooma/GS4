class AddInterfaceToNetworkSetting < ActiveRecord::Migration
  def self.up
    add_column :network_settings, :interface, :string
  end

  def self.down
    remove_column :network_settings, :interface
  end
end
