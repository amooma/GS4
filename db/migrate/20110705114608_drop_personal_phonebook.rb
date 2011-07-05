class DropPersonalPhonebook < ActiveRecord::Migration
  def self.up
   drop_table :personal_phonebooks
  end

  def self.down
   create_table :personal_phonebooks do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :phone_number

      t.timestamps
    end

  end
end
