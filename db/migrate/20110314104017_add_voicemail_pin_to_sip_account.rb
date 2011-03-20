class AddVoicemailPinToSipAccount < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :voicemail_pin, :integer
  end

  def self.down
    remove_column :sip_accounts, :voicemail_pin
  end
end
