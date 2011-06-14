Factory.define :call_forward_reason do |f|
  #reasons = [ 'busy', 'noanswer', 'offline', 'always', 'assistant' ]
  reasons = [ 'busy', 'offline', 'always' ]
  f.sequence( :value ) { |n| "#{reasons[n % 5]}" }
end
