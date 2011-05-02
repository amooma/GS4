class CreatePua < ActiveRecord::Migration
  def self.up
    create_table :pua do |t|
      t.string :pres_uri
      t.string :pres_id
      t.integer :event
      t.integer :expires
      t.integer :desired_expires
      t.integer :flag
      t.string :etag
      t.string :tuple_id
      t.string :watcher_uri
      t.string :call_id
      t.string :to_tag
      t.string :from_tag
      t.integer :cseq
      t.string :record_route
      t.string :contact
      t.string :remote_contact
      t.integer :version
      t.string :extra_headers

      t.timestamps
    end
  end

  def self.down
    drop_table :pua
  end
end
