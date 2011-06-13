Factory.define :conference do |f|
  f.sequence( :name   ) { |n| "conference#{n}" }
  f.sequence( :pin    ) { |n| "1234" }
  f.sequence( :uuid   ) { |n| "-conference-#{n}" }
end
