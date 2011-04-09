class AddHostToSipServer < ActiveRecord::Migration
  def self.up
    add_column :sip_servers, :host, :string
  end

  def self.down
    remove_column :sip_servers, :host
  end
end
