class AddSentToFaxDocuments < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :sent, :datetime
  end

  def self.down
    remove_column :fax_documents, :sent
  end
end
