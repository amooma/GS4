class RemoveExtensionIdFromConference < ActiveRecord::Migration
  def self.up
    remove_column :conferences, :extension_id
  end

  def self.down
    add_column :conferences, :extension_id, :integer
  end
end
