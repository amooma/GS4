class CallQueueToExtension < ActiveRecord::Base
  belongs_to :extension, :dependent => :destroy
  belongs_to :call_queue
end
