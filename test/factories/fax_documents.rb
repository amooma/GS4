#OPTIMIZE Improve factory for fax_documents.
Factory.define :fax_document do |f|
  f.sequence( :file         ) { |n| "file_#{n}" }
  f.sequence( :title        ) { |n| "title_#{n}" }
  f.sequence( :raw_file     ) { |n| "raw_file_#{n}" }
  f.sequence( :destination  ) { |n| "destination_#{n}" }
  f.sequence( :received     ) { |n| "received_#{n}" }
  f.sequence( :sent         ) { |n| "sent_#{n}" }
  f.sequence( :outgoing     ) { |n| "outgoing_#{n}" }
end
