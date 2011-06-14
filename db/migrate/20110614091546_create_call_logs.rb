class CreateCallLogs < ActiveRecord::Migration
  def self.up
    create_table :call_logs do |t|
      t.integer :sip_account_id
      t.string :source
      t.string :destination
      t.string :type
      t.string :disposition
      t.string :forwarded_to

      t.timestamps
    end
  end

  def self.down
    drop_table :call_logs
  end
end
