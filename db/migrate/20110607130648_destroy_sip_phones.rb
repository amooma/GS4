class DestroySipPhones < ActiveRecord::Migration
  def self.up
     drop_table :sip_phones
  end

  def self.down
     create_table :sip_phones do |t|
        t.integer :phone_id
        t.integer :provisioning_server_id

        t.timestamps
     end
  end
end
