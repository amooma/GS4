# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :phone_key_function_definition do |f|
  f.sequence(:name) { |n| "KeyFunctionDefinition #{n}" }
  f.type_of_class "string"
  f.regex_validation nil
end
