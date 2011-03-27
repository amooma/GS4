class CreateVoicemailServers < ActiveRecord::Migration
  def self.up
    create_table :voicemail_servers do |t|
      t.string  :host
      t.integer :port
      t.string  :management_host
      t.integer :management_port

      t.timestamps
    end
  end

  def self.down
    drop_table :voicemail_servers
  end
end
