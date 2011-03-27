class VoicemailServer < ActiveRecord::Base
  
  #has_many :sip_accounts
  
  validates_presence_of      :host
  validates_uniqueness_of    :host
  validate_hostname_or_ip    :host
  validates_numericality_of( :port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
  
  validates_uniqueness_of    :management_host
  validate_hostname_or_ip    :management_host
  validates_numericality_of( :management_port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
  
  
end
