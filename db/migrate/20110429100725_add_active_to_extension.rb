class AddActiveToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :active, :boolean
  end

  def self.down
    remove_column :extensions, :active
  end
end
