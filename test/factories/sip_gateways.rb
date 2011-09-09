Factory.define :sip_gateway do |f|
	f.sequence(:host) { |n| "host#{n}.example.com" }
	f.sequence(:port) { |n| 5060 + n }
	f.sequence(:realm) { |n| "host#{n}.example.com" }
	f.sequence(:username) { |n| "username#{n}" }
	f.sequence(:password) { |n| "password#{n}" }
	f.sequence(:register) { |n| true }
	f.sequence(:reg_transport) { |n| "udp" }
	f.sequence(:expire) { |n| 1800 }
end
