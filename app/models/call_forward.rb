class CallForward < ActiveRecord::Base
  
  belongs_to :call_forward_reason
  belongs_to :sip_account
  
  validates_presence_of :sip_account
  validates_presence_of :call_forward_reason
  validates_presence_of :destination , :if  => Proc.new { |cf| cf.source.blank? }
  validates_uniqueness_of :call_forward_reason_id, :scope => [ :sip_account_id, :source ]
  
  
  validates_numericality_of :call_timeout,
    :if => Proc.new { |me| me.call_forward_reason_id == CallForwardReason.where( :value => "noanswer").first.id },
    :only_integer => true,
    :less_than_or_equal_to => 100,
    :message => "must be all digits and less than 100"
  
  validates_inclusion_of :call_timeout,
    :in => [ nil ],
    :if => Proc.new { |me| me.call_forward_reason_id != CallForwardReason.where( :value => "noanswer").first.id },
    :message => "must only be set if reason = noanswer."
 
end
