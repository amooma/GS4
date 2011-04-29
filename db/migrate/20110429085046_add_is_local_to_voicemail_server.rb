class AddIsLocalToVoicemailServer < ActiveRecord::Migration
  def self.up
    add_column :voicemail_servers, :is_local, :boolean
  end

  def self.down
    remove_column :voicemail_servers, :is_local
  end
end
