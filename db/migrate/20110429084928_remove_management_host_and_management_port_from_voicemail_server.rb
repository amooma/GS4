class RemoveManagementHostAndManagementPortFromVoicemailServer < ActiveRecord::Migration
  def self.up
    remove_column :voicemail_servers, :management_port
    remove_column :voicemail_servers, :management_host
  end

  def self.down
    add_column :voicemail_servers, :management_host, :string
    add_column :voicemail_servers, :management_port, :integer
  end
end
