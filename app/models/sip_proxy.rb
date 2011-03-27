class SipProxy < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  validates_presence_of      :host
  validates_uniqueness_of    :host
  validate_hostname_or_ip    :host
  validate_hostname_or_ip   :management_host, :allow_nil => true, :allow_blank => true
  validates_numericality_of( :host_port, :management_host_port, 
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536
  )

  validates_presence_of :management_host, :if => Proc.new {|sip_proxy| sip_proxy.management_host_port}
  validates_presence_of :management_host_port, :if => Proc.new {|sip_proxy| ! sip_proxy.management_host.blank? }



  # TODO tests
end
