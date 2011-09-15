class CreateDialplanRoutes < ActiveRecord::Migration
	
	def self.up
		create_table :dialplan_routes do |t|
			t.string  :eac
			t.integer :pattern_id
			t.integer :user_id
			t.integer :sip_gateway_id
			t.string  :name
			t.integer :position
			
			t.timestamps
		end
	end
	
	def self.down
		drop_table :dialplan_routes
	end
	
end
