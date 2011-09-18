class RemoveIdFromCdr < ActiveRecord::Migration
  def self.up
    remove_column :cdrs, :id
  end

  def self.down
    add_column :cdrs, :id, :integer
  end
end
