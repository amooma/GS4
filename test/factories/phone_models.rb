# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :phone_model do |f|
  f.sequence(:name) { |n| "Manufacturer #{n}" }
  f.max_number_of_sip_accounts 5
  f.number_of_keys 10
  f.association :manufacturer
end
