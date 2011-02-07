class SipPhone < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  has_many :provisioning_servers, :dependent => :destroy
end
