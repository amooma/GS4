class VoicemailServer < ActiveRecord::Base
  
  #has_many :sip_accounts
  
  validates_presence_of      :host
  validate_hostname_or_ip    :host
  validates_uniqueness_of    :host
  validates_numericality_of( :port,
    :allow_nil    => true,              # empty SIP port means default SIP port (SRV lookups!)
    :greater_than =>     0,
    :less_than    => 65536,
  )
  
  validate_hostname_or_ip(   :management_host, {
    :message => "must be a valid hostname or IP address if set",
    :allow_nil   => true,
    :allow_blank => true,
  })
  validates_uniqueness_of    :management_host
  validates_numericality_of( :management_port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
  
  #TODO - Tests for the validations.
  
end
