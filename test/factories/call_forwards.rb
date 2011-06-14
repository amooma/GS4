Factory.define :call_forward do |f|
  f.sequence( :destination ) { |n| "#{n}" }
  f.sequence( :call_timeout ) { |n| n }
  f.sequence( :source ) { |n| nil }
  
  f.association :sip_account
  f.association :call_forward_reason
end
