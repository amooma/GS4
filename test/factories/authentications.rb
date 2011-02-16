Factory.define :authentication do |f|
  f.sequence(:user_id) { |n| n }
  f.sequence(:provider) { |n| "provider#{n}" }
  f.sequence(:uid) { |n| "uid#{n}" }
  
  f.association :user
end