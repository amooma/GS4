class RemoveTypeFromCallLog < ActiveRecord::Migration
  def self.up
    remove_column :call_logs, :type
  end

  def self.down
    add_column :call_logs, :type, :string
  end
end
