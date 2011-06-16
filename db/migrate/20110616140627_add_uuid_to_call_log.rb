class AddUuidToCallLog < ActiveRecord::Migration
  def self.up
    add_column :call_logs, :uuid, :string
  end

  def self.down
    remove_column :call_logs, :uuid
  end
end
