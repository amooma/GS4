class AddPortToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :port, :integer
  end

  def self.down
    remove_column :sip_servers, :port
  end
end
