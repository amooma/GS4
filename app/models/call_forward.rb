class CallForward < ActiveRecord::Base
  belongs_to :call_forward_reason
  belongs_to :sip_account
end
