class RemoveProvisioningServerIdFromSipPhones < ActiveRecord::Migration
  def self.up
    remove_column :sip_phones, :provisioning_server_id
  end

  def self.down
    add_column :sip_phones, :provisioning_server_id, :integer
  end
end
