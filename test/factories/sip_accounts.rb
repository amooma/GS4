Factory.define :sip_account do |f|
  f.sequence(:auth_name) { |n| "testauth_name#{n}" }
  f.sequence(:password) { |n| "testpassword#{n}" }
  f.sequence(:realm) { |n| "testrealm#{n}" }
  f.sequence(:caller_name) { |n| "caller name #{n}" }
  f.association :sip_server
  f.association :sip_proxy
end