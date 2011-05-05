class AddCallerNameToSipAccount < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :caller_name, :string
  end

  def self.down
    remove_column :sip_accounts, :caller_name
  end
end
