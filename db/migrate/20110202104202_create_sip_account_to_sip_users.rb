class CreateSipAccountToSipUsers < ActiveRecord::Migration
  def self.up
    create_table :sip_account_to_sip_users do |t|
      t.integer :sip_user_id
      t.integer :sip_account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_account_to_sip_users
  end
end
