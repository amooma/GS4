class AddPositionToSipAccount < ActiveRecord::Migration
  def self.up
    add_column :sip_accounts, :position, :integer
  end

  def self.down
    remove_column :sip_accounts, :position
  end
end
