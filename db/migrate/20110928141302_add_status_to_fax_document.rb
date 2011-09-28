class AddStatusToFaxDocument < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :status, :integer
  end

  def self.down
    remove_column :fax_documents, :status
  end
end
