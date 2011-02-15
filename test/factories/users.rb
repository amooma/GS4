Factory.define :user do |f|
  f.sequence(:username) { |n| "user#{n}" }
  f.sequence(:email) { |n| "user#{n}@example.com" }
  f.sequence(:password) { |n| "password#{n}" }
  f.sequence(:gn) { |n| "User#{n}" }
  f.sequence(:sn) { |n| "User#{n}" }
end