class CreateSipGateways < ActiveRecord::Migration
	
	def self.up
		create_table :sip_gateways do |t|
			t.string   :host
			t.integer  :port
			t.string   :realm
			t.string   :username
			t.string   :password
			t.string   :from_user
			t.string   :from_domain
			t.boolean  :register
			t.string   :reg_transport
			t.integer  :expire
			
			t.timestamps
		end
	end
	
	def self.down
		drop_table :sip_gateways
	end
	
end
