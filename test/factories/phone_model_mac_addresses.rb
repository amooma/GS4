# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :phone_model_mac_address do |f|
  f.sequence(:starts_with) { |n| ('%06d' % n).to_s }
  f.association :phone_model
end
