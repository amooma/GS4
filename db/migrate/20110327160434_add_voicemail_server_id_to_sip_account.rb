class AddVoicemailServerIdToSipAccount < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :voicemail_server_id, :integer
  end

  def self.down
    remove_column :sip_accounts, :voicemail_server_id
  end
end
