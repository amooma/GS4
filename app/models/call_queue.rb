class CallQueue < ActiveRecord::Base
  has_many :call_queue_to_extensions, :dependent => :destroy
  has_many :extensions, :through => :call_queue_to_extensions
  
  accepts_nested_attributes_for :extensions
  
  validates_uniqueness_of :uuid
  validates_presence_of :uuid
  
  validate_username :uuid
  # OPTIMIZE :uuid length = "-queue-" + 10
  validates_format_of :uuid, :with => /^-queue-.*$/,
    :allow_nil => false, :allow_blank => false
end
