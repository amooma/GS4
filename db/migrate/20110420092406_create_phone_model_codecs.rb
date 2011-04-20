class CreatePhoneModelCodecs < ActiveRecord::Migration
  def self.up
    create_table :phone_model_codecs do |t|
      t.integer :phone_model_id
      t.integer :codec_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_model_codecs
  end
end
