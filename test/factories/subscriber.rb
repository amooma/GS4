Factory.define :subscriber do |f|
  f.sequence(:username) { |n| "subscriber_username_#{n}" }
  f.sequence(:domain) { |n| "subscriber_domain_#{n}" }
  f.sequence(:password) { |n| "subscriber_password_#{n}" }
  f.sequence(:email_address) { |n| "subscriber_email_address_#{n}" }
  f.sequence(:ha1) { |n| "subscriber_ha1_#{n}" }
  f.sequence(:ha1b) { |n| "subscriber_ha1b_#{n}" }
  f.sequence(:rpid) { |n| "subscriber_rpid_#{n}" }
end
