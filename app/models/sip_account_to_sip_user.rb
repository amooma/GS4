class SipAccountToSipUser < ActiveRecord::Base
  validates_presence_of(:sip_user_id, :message => "sip_user_id needed")
  validates_presence_of(:sip_account_id, :message => "sip_account_id needed")
  validates_numericality_of(:sip_account_id, :message => "sip_account_id mus be a number")
  validates_numericality_of(:sip_user_id, :message => "sip_user_id must be a number")
end
