class AddManagementHostToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :management_host, :string
  end

  def self.down
    remove_column :sip_servers, :management_host
  end
end
