Factory.define :provisioning_server do |f|
  f.sequence(:name) { |n| "10.10.0.#{n}" }
  f.sequence(:port) { |n| n }
end