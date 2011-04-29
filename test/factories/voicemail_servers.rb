# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :voicemail_server do |f|
  f.sequence(:host) { |n| "vm-server-#{n}.localdomain" }
  f.port 4000
  f.is_local false
end
