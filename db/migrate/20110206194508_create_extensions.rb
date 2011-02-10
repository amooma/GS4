class CreateExtensions < ActiveRecord::Migration
  def self.up
    create_table :extensions do |t|
      t.integer :sip_user_id
      t.integer :extension

      t.timestamps
    end
  end

  def self.down
    drop_table :extensions
  end
end
