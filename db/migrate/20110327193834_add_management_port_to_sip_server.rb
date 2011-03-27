class AddManagementPortToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :management_port, :integer
  end

  def self.down
    remove_column :sip_servers, :management_port
  end
end
