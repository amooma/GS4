# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :phone_key_to_function_mapping do |f|
  # f.phone_model_key_id 1
  # f.phone_key_function_definitions_id 1
  f.association :phone_model_key
  f.association :phone_key_function_definition
  
end
