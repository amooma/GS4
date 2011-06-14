class RemoveRemoteNameFromCallLog < ActiveRecord::Migration
  def self.up
    remove_column :call_logs, :remote_name
  end

  def self.down
    add_column :call_logs, :remote_name, :string
  end
end
