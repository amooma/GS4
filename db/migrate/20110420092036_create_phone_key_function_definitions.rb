class CreatePhoneKeyFunctionDefinitions < ActiveRecord::Migration
  def self.up
    create_table :phone_key_function_definitions do |t|
      t.string :name
      t.string :type_of_class
      t.string :regex_validation

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_key_function_definitions
  end
end
