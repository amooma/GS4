class CreateGlobalContacts < ActiveRecord::Migration
  def self.up
    create_table :global_contacts do |t|
      t.string :lastname
      t.string :firstname
      t.string :phone_private
      t.string :phone_business
      t.string :phone_mobile
      t.string :fax_private
      t.string :fax_business

      t.timestamps
    end
  end

  def self.down
    drop_table :global_contacts
  end
end
