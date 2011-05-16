class CallQueueToExtension < ActiveRecord::Base
  belongs_to :extension
  belongs_to :call_queue
end
