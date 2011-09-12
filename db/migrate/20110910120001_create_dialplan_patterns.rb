class CreateDialplanPatterns < ActiveRecord::Migration
	
	def self.up
		create_table :dialplan_patterns do |t|
			t.string  :pattern
			t.string  :name
			
			t.timestamps
		end
	end
	
	def self.down
		drop_table :dialplan_patterns
	end
	
end
