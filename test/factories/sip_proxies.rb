Factory.define :sip_proxy do |f|
  f.sequence(:name) { |n| "#{n}.proxy.de" }
end