class AddUuidToConference < ActiveRecord::Migration
  def self.up
    add_column :conferences, :uuid, :string
  end

  def self.down
    remove_column :conferences, :uuid
  end
end
