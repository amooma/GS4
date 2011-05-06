Factory.define :extension do |f|
  f.sequence( :extension      ) { |n| "x#{n}" }
  f.sequence( :destination    ) { |n| "y#{n}" }
  f.sequence( :active         ) { |n| true }
end
