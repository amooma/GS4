class CreateCdrs < ActiveRecord::Migration
  def self.up
    create_table :cdrs do |t|
      t.string :caller_id_name
      t.string :caller_id_number
      t.string :destination_number
      t.string :context
      t.datetime :start_stamp
      t.datetime :answer_stamp
      t.datetime :end_stamp
      t.integer :duration
      t.integer :billsec
      t.string :hangup_cause
      t.string :uuid
      t.string :bleg_uuid
      t.string :account_code

      t.timestamps
    end
  end

  def self.down
    drop_table :cdrs
  end
end
