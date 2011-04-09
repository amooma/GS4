class AddSipAccountIdToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :sip_account_id, :integer
  end

  def self.down
    remove_column :extensions, :sip_account_id
  end
end
