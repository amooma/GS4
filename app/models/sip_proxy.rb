class SipProxy < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  validates_presence_of(:name, :message => ":name missing")
  validates_uniqueness_of(:name, :message => "Server already exists")
  validate_hostname_or_ip(:name)
end
