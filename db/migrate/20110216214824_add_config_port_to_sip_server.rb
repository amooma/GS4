class AddConfigPortToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :config_port, :integer
  end

  def self.down
    remove_column :sip_servers, :config_port
  end
end
