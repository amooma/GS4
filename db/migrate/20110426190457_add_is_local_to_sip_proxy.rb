class AddIsLocalToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :is_local, :boolean
  end

  def self.down
    remove_column :sip_proxies, :is_local
  end
end
