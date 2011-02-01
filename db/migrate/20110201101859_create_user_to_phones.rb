class CreateUserToPhones < ActiveRecord::Migration
  def self.up
    create_table :user_to_phones do |t|
      t.integer :user_id
      t.integer :phone_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_to_phones
  end
end
