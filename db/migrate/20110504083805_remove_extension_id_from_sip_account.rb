class RemoveExtensionIdFromSipAccount < ActiveRecord::Migration
  def self.up
    remove_column :sip_accounts, :extension_id
  end

  def self.down
    add_column :sip_accounts, :extension_id, :integer
  end
end
