# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :provisioning_log_entry do |f|
  f.memo "normal provisioning"
  f.succeeded true
  f.association :phone
end
