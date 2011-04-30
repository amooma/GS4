class CreateNodes < ActiveRecord::Migration
	
	def self.up
		create_table :nodes do |t|
			t.string  :management_host  , :limit => 64, :null => false
			t.integer :management_port  , :limit => 4, :null => true
			# 2 bytes (16 bits) are enough for the port (up to
			# pow(2,16)-1) but ActiveRecord doesn't support
			# unsigned integers so we need 3 bytes. And for
			# compatibility we'll use 4 bytes (32 bits).
			t.string  :title            , :limit => 60, :null => false
			
			t.timestamps
		end
		add_index( :nodes, [ :management_host, :management_port ], {
			:name   => 'management_host_port',
			:unique => true,
		})
		add_index( :nodes, [ :title ], {
			:name   => 'title',
			:unique => true,
		})
		
		Node.create({
			# management_host must be reachable from all nodes, i.e.
			# "localhost" works if you have only 1 node.
			:management_host => 'localhost',
			:management_port => nil,  # default port
			:title => 'Single-server dummy node',
		})
	end
	
	def self.down
		remove_index :nodes, :name => 'management_host_port'
		remove_index :nodes, :name => 'title'
		drop_table :nodes
	end
	
end
