class RemoveSipPhoneIdFromSipAccount < ActiveRecord::Migration
  def self.up
    remove_column :sip_accounts, :sip_phone_id
  end

  def self.down
    add_column :sip_accounts, :sip_phone_id, :integer
  end
end
