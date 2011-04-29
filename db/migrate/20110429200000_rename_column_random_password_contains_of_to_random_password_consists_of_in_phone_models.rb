class RenameColumnRandomPasswordContainsOfToRandomPasswordConsistsOfInPhoneModels < ActiveRecord::Migration
	
	def self.up
		rename_column :phone_models, :random_password_contains_of, :random_password_consists_of
	end
	
	def self.down
		rename_column :phone_models, :random_password_consists_of, :random_password_contains_of
	end
	
end
