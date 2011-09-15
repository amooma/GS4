class AddSourceToFaxDocument < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :source, :string
  end

  def self.down
    remove_column :fax_documents, :source
  end
end
