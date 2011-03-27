class RemoveNameFromSipProxy < ActiveRecord::Migration
  def self.up
    remove_column :sip_proxies, :name
  end

  def self.down
    add_column :sip_proxies, :name, :string
  end
end
