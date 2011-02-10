class AddSnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sn, :string
  end

  def self.down
    remove_column :users, :sn
  end
end
