class RemoveSipUserIdFromExtension < ActiveRecord::Migration
  def self.up
    remove_column :extensions, :sip_user_id
  end

  def self.down
    add_column :extensions, :sip_user_id, :integer
  end
end
