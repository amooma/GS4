# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :sip_server do |f|
  f.sequence(:name) { |n| "#{n}.server.de" }
  f.managed_by_gs false
end