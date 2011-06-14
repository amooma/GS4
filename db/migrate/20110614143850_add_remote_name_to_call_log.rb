class AddRemoteNameToCallLog < ActiveRecord::Migration
  def self.up
    add_column :call_logs, :remote_name, :string
  end

  def self.down
    remove_column :call_logs, :remote_name
  end
end
