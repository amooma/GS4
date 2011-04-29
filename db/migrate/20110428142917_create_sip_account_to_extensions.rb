class CreateSipAccountToExtensions < ActiveRecord::Migration
  def self.up
    create_table :sip_account_to_extensions do |t|
      t.integer :sip_account_id
      t.integer :extension_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_account_to_extensions
  end
end
