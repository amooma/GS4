class CreatePhoneKeys < ActiveRecord::Migration
  def self.up
    create_table :phone_keys do |t|
      t.integer :phone_model_key_id
      t.integer :phone_key_function_definition_id
      t.string :value
      t.string :label
      t.integer :sip_account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_keys
  end
end
