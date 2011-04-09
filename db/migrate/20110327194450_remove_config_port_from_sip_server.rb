class RemoveConfigPortFromSipServer < ActiveRecord::Migration
  def self.up
    remove_column :sip_servers, :config_port
  end

  def self.down
    add_column :sip_servers, :config_port, :integer
  end
end
