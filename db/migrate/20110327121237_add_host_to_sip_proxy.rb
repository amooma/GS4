class AddHostToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :host, :string
  end

  def self.down
    remove_column :sip_proxies, :host
  end
end
