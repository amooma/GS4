class RemoveConfigPortFromSipProxy < ActiveRecord::Migration
  def self.up
    remove_column :sip_proxies, :config_port
  end

  def self.down
    add_column :sip_proxies, :config_port, :integer
  end
end
