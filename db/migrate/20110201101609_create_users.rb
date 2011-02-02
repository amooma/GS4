class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :uid
      t.string :gn
      t.string :sn
      t.string :mail
      t.string :userPassword

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
