class AddSourceToCallForward < ActiveRecord::Migration
  def self.up
    add_column :call_forwards, :source, :string
  end

  def self.down
    remove_column :call_forwards, :source
  end
end
