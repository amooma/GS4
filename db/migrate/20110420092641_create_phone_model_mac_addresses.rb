class CreatePhoneModelMacAddresses < ActiveRecord::Migration
  def self.up
    create_table :phone_model_mac_addresses do |t|
      t.integer :phone_model_id
      t.string :starts_with

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_model_mac_addresses
  end
end
