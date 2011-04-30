class AddNodeIdToSipPhones < ActiveRecord::Migration
  def self.up
    add_column :sip_phones, :node_id, :integer
  end

  def self.down
    remove_column :sip_phones, :node_id
  end
end
