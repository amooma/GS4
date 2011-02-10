class AddExtensionIdToSipAccount < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :extension_id, :integer
  end

  def self.down
    remove_column :sip_accounts, :extension_id
  end
end
