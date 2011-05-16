class CreateCallQueueToExtensions < ActiveRecord::Migration
  def self.up
    create_table :call_queue_to_extensions do |t|
      t.integer :call_queue_id
      t.integer :extension_id

      t.timestamps
    end
  end

  def self.down
    drop_table :call_queue_to_extensions
  end
end
