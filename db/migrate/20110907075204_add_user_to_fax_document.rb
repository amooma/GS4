class AddUserToFaxDocument < ActiveRecord::Migration
  def self.up
    add_column :fax_documents, :user_id, :integer
  end

  def self.down
    remove_column :fax_documents, :user_id
  end
end
