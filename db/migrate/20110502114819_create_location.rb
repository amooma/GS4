class CreateLocation < ActiveRecord::Migration
  def self.up
    create_table :location do |t|
      t.string :username
      t.string :domain
      t.string :contact
      t.string :received
      t.string :path
      t.datetime :expires
      t.float :q
      t.string :callid
      t.integer :cseq
      t.datetime :last_modified
      t.integer :flags
      t.string :user_agent
      t.string :socket
      t.integer :methods

      t.timestamps
    end
  end

  def self.down
    drop_table :location
  end
end
