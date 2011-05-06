# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :reboot_request do |f|
  f.association :phone
  f.start Time.now
  f.successful false
end
