# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :oui do |f|
  f.sequence(:value) { |n| (n + 11184810).to_s(16).upcase }
  f.association :manufacturer
end
