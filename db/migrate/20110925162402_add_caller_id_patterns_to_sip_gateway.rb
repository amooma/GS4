class AddCallerIdPatternsToSipGateway < ActiveRecord::Migration
  def self.up
    add_column :sip_gateways, :caller_id_patterns, :string
  end

  def self.down
    remove_column :sip_gateways, :caller_id_patterns
  end
end
