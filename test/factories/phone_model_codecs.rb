# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :phone_model_codec do |f|
  f.association :phone_model
  f.association :codec
end
