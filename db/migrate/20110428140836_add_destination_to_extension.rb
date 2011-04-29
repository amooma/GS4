class AddDestinationToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :destination, :string
  end

  def self.down
    remove_column :extensions, :destination
  end
end
