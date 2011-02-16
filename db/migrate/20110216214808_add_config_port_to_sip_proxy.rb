class AddConfigPortToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :config_port, :integer
  end

  def self.down
    remove_column :sip_proxies, :config_port
  end
end
