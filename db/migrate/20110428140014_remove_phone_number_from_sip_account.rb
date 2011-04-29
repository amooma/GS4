class RemovePhoneNumberFromSipAccount < ActiveRecord::Migration
  def self.up
    remove_column :sip_accounts, :phone_number
  end

  def self.down
    add_column :sip_accounts, :phone_number, :integer
  end
end
