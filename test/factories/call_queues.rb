Factory.define :call_queue do |f|
  f.sequence( :name   ) { |n| "queue#{n}" }
  f.sequence( :uuid   ) { |n| "-queue-#{n}" }
end
