class RemoveManagedByGsFromSipServer < ActiveRecord::Migration
  def self.up
    remove_column :sip_servers, :managed_by_gs
  end

  def self.down
    add_column :sip_servers, :managed_by_gs, :boolean
  end
end
