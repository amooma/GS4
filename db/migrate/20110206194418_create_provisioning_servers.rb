class CreateProvisioningServers < ActiveRecord::Migration
  def self.up
    create_table :provisioning_servers do |t|
      t.string :name
      t.integer :port

      t.timestamps
    end
  end

  def self.down
    drop_table :provisioning_servers
  end
end
