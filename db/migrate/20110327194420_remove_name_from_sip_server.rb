class RemoveNameFromSipServer < ActiveRecord::Migration
  def self.up
    remove_column :sip_servers, :name
  end

  def self.down
    add_column :sip_servers, :name, :string
  end
end
