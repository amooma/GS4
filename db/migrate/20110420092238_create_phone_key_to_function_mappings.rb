class CreatePhoneKeyToFunctionMappings < ActiveRecord::Migration
  def self.up
    create_table :phone_key_to_function_mappings do |t|
      t.integer :phone_model_key_id
      t.integer :phone_key_function_definition_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_key_to_function_mappings
  end
end
