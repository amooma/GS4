class CreatePhoneModelKeys < ActiveRecord::Migration
  def self.up
    create_table :phone_model_keys do |t|
      t.string :name
      t.integer :phone_model_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_model_keys
  end
end
