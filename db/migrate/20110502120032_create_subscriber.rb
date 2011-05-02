class CreateSubscriber < ActiveRecord::Migration
  def self.up
    create_table :subscriber do |t|
      t.string :username
      t.string :domain
      t.string :password
      t.string :email_address
      t.integer :datetime_created
      t.integer :datetime_modified
      t.string :ha1
      t.string :ha1b
      t.string :rpid

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribers
  end
end
