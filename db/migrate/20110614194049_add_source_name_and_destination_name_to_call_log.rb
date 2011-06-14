class AddSourceNameAndDestinationNameToCallLog < ActiveRecord::Migration
  def self.up
    add_column :call_logs, :source_name, :string
    add_column :call_logs, :destination_name, :string
  end

  def self.down
    remove_column :call_logs, :remote_name
    remove_column :call_logs, :destination_name
  end
end
