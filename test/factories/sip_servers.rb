# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :sip_server do |f|
  f.sequence(:host) { |n| "#{n}.server.de" }
  f.is_local false
end