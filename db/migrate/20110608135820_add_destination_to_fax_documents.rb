class AddDestinationToFaxDocuments < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :destination, :string
  end

  def self.down
    remove_column :fax_documents, :destination
  end
end
