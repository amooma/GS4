class CreateCallForwardReasons < ActiveRecord::Migration
  def self.up
    create_table :call_forward_reasons do |t|
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :call_forward_reasons
  end
end
