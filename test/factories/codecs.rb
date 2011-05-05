# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :codec do |f|
  f.sequence(:name) { |n| "Codec_#{n}" }
end
