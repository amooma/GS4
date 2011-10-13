class CreateCallForwardHops < ActiveRecord::Migration
  def self.up
    create_table :call_forward_hops do |t|
      t.string :uuid
      t.integer :hop

      t.timestamps
    end
  end

  def self.down
    drop_table :call_forward_hops
  end
end
