Factory.define :provisioning_server do |f|
  f.sequence(:name) { |n| "#{n}.test.de" }
  f.sequence(:port) { |n| n }
end