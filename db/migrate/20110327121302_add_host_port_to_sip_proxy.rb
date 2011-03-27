class AddHostPortToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :host_port, :integer
  end

  def self.down
    remove_column :sip_proxies, :host_port
  end
end
