Factory.define :call_forward do |f|
  f.association :sip_account
  #f.sequence( :call_forward_reason_id ) { |n| CallForwardReason.where(:value => "always").first.id }
  f.association :call_forward_reason
  f.sequence( :destination  ) { |n| "#{n}" }
  f.sequence( :call_timeout ) { |n| nil }
  f.sequence( :source       ) { |n| "#{n}" }
  f.sequence( :active       ) { |n| false }
end
