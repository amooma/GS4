class CreateSipAccounts < ActiveRecord::Migration
  def self.up
    create_table :sip_accounts do |t|
      t.integer :user_id
      t.string :auth_name
      t.string :password
      t.string :realm
      t.integer :phone_number
      t.integer :sip_server_id
      t.integer :sip_proxy_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_accounts
  end
end
