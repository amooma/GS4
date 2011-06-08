class AddReceivedToFaxDocuments < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :received, :datetime
  end

  def self.down
    remove_column :fax_documents, :received
  end
end
