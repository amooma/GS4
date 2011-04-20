class CreateSipAccountCodecs < ActiveRecord::Migration
  def self.up
    create_table :sip_account_codecs do |t|
      t.integer :codec_id
      t.integer :sip_account_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_account_codecs
  end
end
