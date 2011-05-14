class CreateConferenceToExtensions < ActiveRecord::Migration
  def self.up
    create_table :conference_to_extensions do |t|
      t.integer :conference_id
      t.integer :extension_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :conference_to_extensions
  end
end
