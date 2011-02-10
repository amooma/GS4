class AddGnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gn, :string
  end

  def self.down
    remove_column :users, :gn
  end
end
