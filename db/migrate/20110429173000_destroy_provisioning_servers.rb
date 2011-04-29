class DestroyProvisioningServers < ActiveRecord::Migration
	
	def self.up
		drop_table :provisioning_servers
	end
	
	def self.down
		create_table :provisioning_servers do |t|
			t.string  :name
			t.integer :port
			
			t.timestamps
		end
	end
	
end

