class CreateVersion < ActiveRecord::Migration
  def self.up
    create_table :version do |t|
      t.string :table_name
      t.integer :table_version

      t.timestamps
    end
  end

  def self.down
    drop_table :version
  end
end
