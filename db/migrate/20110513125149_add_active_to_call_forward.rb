class AddActiveToCallForward < ActiveRecord::Migration
  def self.up
    add_column :call_forwards, :active, :boolean
  end

  def self.down
    remove_column :call_forwards, :active
  end
end
