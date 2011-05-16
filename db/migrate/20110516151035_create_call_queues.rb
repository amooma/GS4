class CreateCallQueues < ActiveRecord::Migration
  def self.up
    create_table :call_queues do |t|
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end

  def self.down
    drop_table :call_queues
  end
end
