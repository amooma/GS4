class CreateProvisioningLogEntries < ActiveRecord::Migration
  def self.up
    create_table :provisioning_log_entries do |t|
      t.integer :phone_id
      t.string :memo
      t.boolean :succeeded

      t.timestamps
    end
  end

  def self.down
    drop_table :provisioning_log_entries
  end
end
