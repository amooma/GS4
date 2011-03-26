class SipServer < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  validates_presence_of      :name
  validates_uniqueness_of    :name
  validate_hostname_or_ip    :name
  validates_numericality_of( :config_port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
end

