# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :phone_model_key do |f|
  f.sequence(:name) { |n| "Functionkey #{n}" }
  f.association :phone_model
end
