# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :sip_phone do |f|
  f.sequence(:phone_id) { |n| n }
  f.association :provisioning_server
end