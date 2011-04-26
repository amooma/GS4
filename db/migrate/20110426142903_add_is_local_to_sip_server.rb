class AddIsLocalToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :is_local, :boolean
  end

  def self.down
    remove_column :sip_servers, :is_local
  end
end
