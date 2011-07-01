class CreatePersonalPhonebooks < ActiveRecord::Migration
  def self.up
    create_table :personal_phonebooks do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :personal_phonebooks
  end
end
