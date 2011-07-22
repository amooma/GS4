Factory.define :configuration do |f|
  f.sequence( :name     ) { |n| "name#{n}" }
  f.sequence( :value    ) { |n| "value#{n}" }
end
