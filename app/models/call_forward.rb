class CallForward < ActiveRecord::Base
  belongs_to :call_forward_reason
  belongs_to :sip_account
  
  validates_presence_of :sip_account
  validates_presence_of :call_forward_reason
  validates_presence_of :destination , :if  => Proc.new { |cf| cf.source.empty? }
  validates_uniqueness_of :call_forward_reason_id, :scope => [ :sip_account_id, :source ]
  
end
