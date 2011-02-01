class CreateUserToSipAccounts < ActiveRecord::Migration
  def self.up
    create_table :user_to_sip_accounts do |t|
      t.integer :user_id
      t.integer :sip_account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_to_sip_accounts
  end
end
