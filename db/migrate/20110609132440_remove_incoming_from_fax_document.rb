class RemoveIncomingFromFaxDocument < ActiveRecord::Migration
  def self.up
    remove_column :fax_documents, :incoming
  end

  def self.down
    add_column :fax_documents, :incoming, :boolean
  end
end
