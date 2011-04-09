class AddManagedByGsToSipProxy < ActiveRecord::Migration
  def self.up
    add_column :sip_proxies, :managed_by_gs, :boolean
  end

  def self.down
    remove_column :sip_proxies, :managed_by_gs
  end
end
