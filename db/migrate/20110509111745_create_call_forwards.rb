class CreateCallForwards < ActiveRecord::Migration
  def self.up
    create_table :call_forwards do |t|
      t.integer :sip_account_id
      t.integer :call_forward_reason_id
      t.string :destination
      t.integer :call_timeout

      t.timestamps
    end
  end

  def self.down
    drop_table :call_forwards
  end
end
