class SipUser < ActiveRecord::Base
  belongs_to :sip_server
  belongs_to :sip_proxy
  has_many :sip_account_to_sip_users, :dependent => :destroy
end
