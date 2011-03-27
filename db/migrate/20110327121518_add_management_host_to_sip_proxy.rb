class AddManagementHostToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :management_host, :string
  end

  def self.down
    remove_column :sip_proxies, :management_host
  end
end
