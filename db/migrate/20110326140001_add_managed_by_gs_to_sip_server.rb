class AddManagedByGsToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :managed_by_gs, :boolean
  end

  def self.down
    remove_column :sip_servers, :managed_by_gs
  end
end
