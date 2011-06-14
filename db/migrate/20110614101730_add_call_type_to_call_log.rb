class AddCallTypeToCallLog < ActiveRecord::Migration
  def self.up
    add_column :call_logs, :call_type, :string
  end

  def self.down
    remove_column :call_logs, :call_type
  end
end
