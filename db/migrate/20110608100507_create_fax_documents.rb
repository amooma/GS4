class CreateFaxDocuments < ActiveRecord::Migration
  def self.up
    create_table :fax_documents do |t|
      t.string :file
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :fax_documents
  end
end
