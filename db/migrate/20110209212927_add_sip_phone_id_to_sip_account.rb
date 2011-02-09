class AddSipPhoneIdToSipAccount < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :sip_phone_id, :integer
  end

  def self.down
    remove_column :sip_accounts, :sip_phone_id
  end
end
