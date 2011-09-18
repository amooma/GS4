class CreateSystemInfos < ActiveRecord::Migration
  def self.up
    create_table :system_infos do |t|
      t.integer :diskfree_data
      t.integer :diskfree_db
      t.float :load_avg
      t.integer :memory_free

      t.timestamps
    end
  end

  def self.down
    drop_table :system_infos
  end
end
