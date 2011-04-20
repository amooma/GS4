class RebootRequest < ActiveRecord::Base
validates_presence_of :phone_id
  validates_numericality_of :phone_id, :only_integer => true, :greater_than_or_equal_to => 0
  belongs_to :phone
  default_value_for :start, Time.now
  default_value_for :successful, false
end
