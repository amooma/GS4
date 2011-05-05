# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :manufacturer do |f|
  f.sequence(:name) { |n| "Manufacturer #{n}" }
end
