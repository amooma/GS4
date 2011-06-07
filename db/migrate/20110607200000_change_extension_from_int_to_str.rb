class ChangeExtensionFromIntToStr < ActiveRecord::Migration
	
	def self.up
		change_column :extensions, :extension, :string
	end
	
	def self.down
		change_column :extensions, :extension, :integer
	end
	
end
