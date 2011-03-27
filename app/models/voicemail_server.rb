class VoicemailServer < ActiveRecord::Base
  
  has_many :sip_accounts, :dependent => :nullify
  
  validates_presence_of      :host
  validate_hostname_or_ip    :host
  validates_uniqueness_of    :host
  
  validate_ip_port           :port, :allow_nil => true  # empty SIP port means default SIP port (SRV lookups)
  
  validate_hostname_or_ip(   :management_host, {
    :message => "must be a valid hostname or IP address if set.",
    :allow_nil   => true,
    :allow_blank => true,
  })
  validates_uniqueness_of    :management_host
  
  validate_ip_port           :management_port, :allow_nil => true
  
  validates_presence_of :management_port,
    :message => "must be present if a management host is set.",
    :if => Proc.new { |vm_server| ! vm_server.management_host.blank? }
  
  validates_presence_of :management_host,
    :message => "must be present if a management port is set.",
    :if => Proc.new { |vm_server| ! vm_server.management_port.blank? }
    
end
