class CreateRebootRequests < ActiveRecord::Migration
  def self.up
    create_table :reboot_requests do |t|
      t.integer :phone_id
      t.datetime :start
      t.datetime :end
      t.boolean :successful

      t.timestamps
    end
  end

  def self.down
    drop_table :reboot_requests
  end
end
