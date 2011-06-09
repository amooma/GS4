class AddIncomingAndOutgoingToFaxDocument < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :incoming, :boolean
    add_column :fax_documents, :outgoing, :boolean
  end

  def self.down
    remove_column :fax_documents, :outgoing
    remove_column :fax_documents, :incoming
  end
end
