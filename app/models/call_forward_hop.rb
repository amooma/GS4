class CallForwardHop < ActiveRecord::Base
  default_value_for :hop, 0
  validates_presence_of :uuid
  validates_numericality_of :hop, :allow_nil => true
  before_create {
    self.hop = 0 if self.hop.nil?
  }
  
  after_save {
    CallForwardHop.where("updated_at < :recent", {:recent => 10.seconds.ago}).destroy_all
  }
end
