# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :sip_proxy do |f|
  f.sequence(:host) { |n| "#{n}.proxy.de" }
  f.is_local false
end