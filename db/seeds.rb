# This file should contain all the record creation needed to seed
# the database with its default values. The data can then be loaded
# with the rake db:seed (or created alongside the db with db:setup).


################################################################
# Nodes
################################################################

Node.create({
	# management_host must be reachable from all nodes, i.e.
	# "localhost" works if you have only 1 node.
	:management_host  => 'localhost',
	:management_port  => nil,  # default port
	:title            => 'Single-server dummy node',
})


################################################################
# Phone key function definitions
################################################################

# General softkey functions:
# DO NOT RENAME THEM! The name is magic and serves as an identifier! (#OPTIMIZE)
#
PhoneKeyFunctionDefinition.create([
	{ :name => 'BLF'              , :type_of_class => 'string'  , :regex_validation => nil },
	{ :name => 'Speed dial'       , :type_of_class => 'string'  , :regex_validation => nil },
	{ :name => 'ActionURL'        , :type_of_class => 'url'     , :regex_validation => nil },
	{ :name => 'Line'             , :type_of_class => 'integer' , :regex_validation => nil },
])


################################################################
# Manufacturers
################################################################

snom    = Manufacturer.find_or_create_by_ieee_name(
	'SNOM Technology AG', {
		:name => "SNOM Technology AG",
		:url  => 'http://www.snom.com/',
})
aastra  = Manufacturer.find_or_create_by_ieee_name(
	'DeTeWe-Deutsche Telephonwerke', {
		:name => "Aastra DeTeWe",
		:url  => 'http://www.aastra.de/',
})
tiptel  = Manufacturer.find_or_create_by_ieee_name(
	'XIAMEN YEALINK NETWORK TECHNOLOGY CO.,LTD', {
		:name => "Tiptel",
		:url  => 'http://www.tiptel.de/'
})
#OPTIMIZE Differentiate between manufacturer and vendor. Make this either Yealink or Tiptel.


################################################################
# OUIs
################################################################

snom    .ouis.create([
	{ :value => '000413'},
])
aastra  .ouis.create([
	{ :value => '003042' },
	{ :value => '00085D' },
])
tiptel  .ouis.create([
	{ :value => '001565' },
])




#TODO Clean up the stuff in following ...



################################################################
# Phone models
################################################################

# Snom
# http://wiki.snom.com/Settings/mac
#

snom.phone_models.create(:name => 'Snom 190').phone_model_mac_addresses.create(:starts_with => '00041322')
snom300 = snom.phone_models.create(:name => 'Snom 300', 
                                   :url => 'http://www.snom.com/en/products/ip-phones/snom-300/',
                                   :max_number_of_sip_accounts =>  2 )
snom300.phone_model_mac_addresses.create([
                                         {:starts_with => '00041325'},
                                         {:starts_with => '00041328'},
                                         {:starts_with => '0004132D'},
                                         {:starts_with => '0004132F'},
                                         {:starts_with => '00041334'},
                                         {:starts_with => '00041350'},
                                         {:starts_with => '0004133B'},
                                         {:starts_with => '00041337'}
                                         ])
# Uncomment the following code if you need all Snom 300 MAC Addresses
# It'll fill your database by some 30,000 items.
#                                                                                
# ('0004133687F0'.hex .. '00041336FFFF'.hex).each do |snom300_mac_address|
#   snom300_mac_address = snom300_mac_address.to_s(16)
#   (snom300_mac_address.length .. 11).each do |i|
#     snom300_mac_address = '0' + snom300_mac_address
#   end
#   snom300.phone_model_mac_addresses.create(:starts_with => snom300_mac_address.upcase)
# end
snom.phone_models.create(:name => 'Snom 320', 
                         :url => 'http://www.snom.com/en/products/ip-phones/snom-320/',
                         :max_number_of_sip_accounts => 12,
                         :number_of_keys => 12 ).
                         phone_model_mac_addresses.create([
                           {:starts_with => '00041324'},
                           {:starts_with => '00041327'},
                           {:starts_with => '0004132C'},
                           {:starts_with => '00041331'},
                           {:starts_with => '00041335'},
                           {:starts_with => '00041338'},
                           {:starts_with => '00041351'}
                                         ])
snom.phone_models.create(:name => 'Snom 360', 
                        :url => 'http://www.snom.com/en/products/ip-phones/snom-360/',
                        :max_number_of_sip_accounts => 12,
                        :number_of_keys => 12 ).
                        phone_model_mac_addresses.create([
                          {:starts_with => '00041323'},
                          {:starts_with => '00041329'},
                          {:starts_with => '0004132B'},
                          {:starts_with => '00041339'},
                          {:starts_with => '00041390'}
                                        ])
snom.phone_models.create(:name => 'Snom 370', 
                        :url => 'http://www.snom.com/en/products/ip-phones/snom-370/',
                        :max_number_of_sip_accounts => 12,
                        :number_of_keys => 12 ).
                        phone_model_mac_addresses.create([
                          {:starts_with => '00041326'},
                          {:starts_with => '0004132E'},
                          {:starts_with => '0004133A'},
                          {:starts_with => '00041352'}
                                        ])
snom.phone_models.create(:name => 'Snom 820', 
                        :url => 'http://www.snom.com/en/products/ip-phones/snom-820/',
                        :max_number_of_sip_accounts => 12,
                        :number_of_keys => 12 ).
			phone_model_mac_addresses.create([
                          {:starts_with => '00041340'},
                                        ])
snom.phone_models.create(:name => 'Snom 821', 
                        :url => 'http://www.snom.com/en/products/ip-phones/snom-821/',
                        :max_number_of_sip_accounts => 12,
                        :number_of_keys => 12 ).
                        phone_model_mac_addresses.create([
                          {:starts_with => '00041345'}
                                        ])
snom.phone_models.create(:name => 'Snom 870', 
                        :url => 'http://www.snom.com/en/products/ip-phones/snom-870/',
                        :max_number_of_sip_accounts => 12,
                        :number_of_keys => 12 ).
                        phone_model_mac_addresses.create([
                          {:starts_with => '00041341'}
                                        ])
			
# Define Snom keys:
snom.phone_models.each do |pm|
	num_exp_modules = 0	
	max_key_idx = pm.number_of_keys.to_i + (42 * num_exp_modules) - 1
	if max_key_idx >= 0
		(0..max_key_idx).each { |idx|
			key = pm.phone_model_keys.create(
				{ :position => idx, :name => "P #{(1+idx).to_s.rjust(3,'0')} (fkey[#{idx}])" }
			)
			key.phone_key_function_definitions << PhoneKeyFunctionDefinition.all 
		}
	end
end

# Set http parameters
snom.phone_models.each do |phone_model|
  phone_model.update_attributes(:http_port => 80, :reboot_request_path => 'confirm.htm?REBOOT=yes', :http_request_timeout => 5)
end

# Set codecs for Snom
snom.phone_models.each do |phone_model|
  [ 'alaw', 'ulaw', 'gsm', 'g722', 'g726', 'g729', 'g723'
  ].each do |codec_name|
    phone_model.codecs << Codec.find_or_create_by_name(codec_name)
  end
end


# Aastra
#
aastra.phone_models.create(:name => '57i',  :max_number_of_sip_accounts => 9, :number_of_keys =>  30,  :url => 'http://www.aastra.com/aastra-6757i.htm')
aastra.phone_models.create(:name => '55i',  :max_number_of_sip_accounts => 9, :number_of_keys =>  26,  :url => 'http://www.aastra.com/aastra-6753i.htm')
aastra.phone_models.create(:name => '53i',  :max_number_of_sip_accounts => 9, :number_of_keys =>  6,   :url => 'http://www.aastra.com/aastra-6753i.htm')
aastra.phone_models.create(:name => '51i',  :max_number_of_sip_accounts => 1, :number_of_keys =>  0,   :url => 'http://www.aastra.com/aastra-6751i.htm')

# Set http parameters
aastra.phone_models.each do |phone_model|
  phone_model.update_attributes(:http_port => 80, :reboot_request_path => 'logout.html', :http_request_timeout => 5, :default_http_user => 'admin',  :default_http_password => '22222', :random_password_consists_of => (0 ..9).to_a.join)
end

aastra.phone_models.each do |phone_model|
  [ 'alaw', 'ulaw', 'g722', 'g726', 'g726-24', 'g726-32', 'g726-40', 'g729', 'bv16', 'bv32', 'ulaw-16k', 'alaw-16k', 'l16', 'l16-8k'
  ].each do |codec_name|
    phone_model.codecs << Codec.find_or_create_by_name(codec_name)
  end
end
  
# Set softkeys
['55i', '57i'].each do |p_model|
 (1..20).each { |mem_num| 
    PhoneModel.where( :name => "#{p_model}" ).first.phone_model_keys.create([
      { :name => "softkey#{mem_num}", :position => "#{mem_num}" }
    ])
    PhoneModel.where( :name => "#{p_model}" ).first.phone_model_keys.where( :name => "softkey#{mem_num}" ).first.phone_key_function_definitions << PhoneKeyFunctionDefinition.all

  } 
end

# Set topsoftkeys
['57i'].each do |p_model|
 (1..10).each { |mem_num| 
    PhoneModel.where( :name => "#{p_model}" ).first.phone_model_keys.create([
      { :name => "topsoftkey#{mem_num}", :position => "#{mem_num+20}" }
    ])
    PhoneModel.where( :name => "#{p_model}" ).first.phone_model_keys.where( :name => "topsoftkey#{mem_num}" ).first.phone_key_function_definitions << PhoneKeyFunctionDefinition.all

  } 
end

# Tiptel
#

tiptel.phone_models.create(:name => 'IP 286', :max_number_of_sip_accounts => 16, :number_of_keys => 10,  :url => 'http://www.tiptel.com/products/details/article/tiptel-ip-286-6/')
tiptel.phone_models.create(:name => 'IP 280', :max_number_of_sip_accounts => 2, :url => 'http://www.tiptel.com/products/details/article/tiptel-ip-280-6/')
tiptel.phone_models.create(:name => 'IP 284', :max_number_of_sip_accounts => 13, :number_of_keys => 10, :url => 'http://www.tiptel.com/products/details/article/tiptel-ip-284-6/')
tiptel.phone_models.create(:name => 'VP 28', :url => 'http://www.tiptel.com/products/details/article/tiptel-vp-28-4/')
tiptel.phone_models.create(:name => 'IP 28 XS', :url => 'http://www.tiptel.com/products/details/article/tiptel-ip-28-xs-6/')

# Set http parameters
tiptel.phone_models.each do |phone_model|
  phone_model.update_attributes(:http_port => 80, :reboot_request_path => '/cgi-bin/ConfigManApp.com', :http_request_timeout => 5, :default_http_user => 'admin',  :default_http_password => 'admin')
end

# Codecs for Tiptel
tiptel.phone_models.each do |phone_model|
  [ "ulaw", "alaw", "g722", "g723", "g726", "g729", "g726-16", "g726-24", "g726-40"
  ].each do |codec_name|
    phone_model.codecs << Codec.find_or_create_by_name(codec_name)
  end
end

['IP 284', 'IP 286'].each do |p_model|
  (1..10).each { |mem_num| 
    PhoneModel.where( :name => "#{p_model}" ).first.phone_model_keys.create([
      { :name => "memory#{mem_num}", :position => "#{mem_num}" }
    ])
    PhoneModel.where( :name => "#{p_model}" ).first.phone_model_keys.where( :name => "memory#{mem_num}" ).first.phone_key_function_definitions << PhoneKeyFunctionDefinition.all

  }
end



################################################################
# Sample phones (test phones)
################################################################


PhoneModel.where(
  :name => 'IP 284' 
).first.phones.create([
  { :mac_address => '00156513EC2F' } 
])


Phone.create(
  :mac_address    => '00-04-13-29-68-87',
  :phone_model_id => PhoneModel.where( :name => 'Snom 360' ).first.id
)

PhoneModel.where(
  :name => '57i' 
).first.phones.create([
  { :mac_address => '00085D24387A' } 
])
PhoneModel.where(
  :name => 'Snom 320' 
).first.phones.create([
  { :mac_address => '000413271FDB' } 
])
PhoneModel.where(
  :name => 'Snom 320' 
).first.phones.create([
  { :mac_address => '000413271FD8' } 
])


