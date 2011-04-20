class CreateOuis < ActiveRecord::Migration
  def self.up
    create_table :ouis do |t|
      t.string :value
      t.integer :manufacturer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ouis
  end
end
