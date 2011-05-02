class AddCflagsToLocation < ActiveRecord::Migration
  def self.up
    add_column :location, :cflags, :integer
  end

  def self.down
    remove_column :location, :cflags
  end
end
