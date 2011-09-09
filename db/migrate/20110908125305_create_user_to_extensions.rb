class CreateUserToExtensions < ActiveRecord::Migration
  def self.up
    create_table :user_to_extensions do |t|
      t.integer :user_id
      t.integer :extension_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_to_extensions
  end
end
