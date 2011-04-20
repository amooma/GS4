class CreateCodecs < ActiveRecord::Migration
  def self.up
    create_table :codecs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :codecs
  end
end
