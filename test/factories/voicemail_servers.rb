# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :voicemail_server do |f|
  f.sequence(:host) { |n| "vm-server-#{n}.localdomain" }
  f.port 4000
  f.sequence(:management_host) { |n| "vm-server-#{n}-mgmt.localdomain" }
  f.management_port 5000
end
