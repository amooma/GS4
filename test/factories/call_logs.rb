Factory.define :call_log do |f|
  f.association :sip_account
  f.sequence( :source       ) { |n| "source#{n}" }
  f.sequence( :destination  ) { |n| "destination#{n}" }
  f.sequence( :disposition  ) { |n| "disposition#{n}" }
  f.sequence( :forwarded_to ) { |n| "forwarded_to#{n}" }
  f.sequence( :call_type    ) { |n| "call_type#{n}" }
  f.sequence( :destination_name  ) { |n| "destination_name#{n}" }
  f.sequence( :source_name  ) { |n| "source_name#{n}" }
end
