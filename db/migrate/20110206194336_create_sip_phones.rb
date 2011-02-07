class CreateSipPhones < ActiveRecord::Migration
  def self.up
    create_table :sip_phones do |t|
      t.integer :phone_id
      t.integer :provisioning_server_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_phones
  end
end
