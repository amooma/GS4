class RemoveSipAccountIdFromExtension < ActiveRecord::Migration
  def self.up
    remove_column :extensions, :sip_account_id
  end

  def self.down
    add_column :extensions, :sip_account_id, :integer
  end
end
