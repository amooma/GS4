Factory.define :node do |f|
  f.sequence(:management_host) { |n| "#{n}.test.local" }
  f.sequence(:management_port) { |n| nil }
  f.sequence(:title) { |n| "Node #{n}" }
end
