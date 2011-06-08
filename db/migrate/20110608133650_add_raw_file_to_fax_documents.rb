class AddRawFileToFaxDocuments < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :raw_file, :string
  end

  def self.down
    remove_column :fax_documents, :raw_file
  end
end
