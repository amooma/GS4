class AddRoleToUsers < ActiveRecord::Migration
  
  def self.up
    add_column :users, :role, :string
    
    # all users so far are admins:
    User.update_all( { :role => "admin" }, { :role => nil } )
    User.update_all( { :role => "admin" }, { :role => ""  } )
  end

  def self.down
    remove_column :users, :role
  end
  
end
