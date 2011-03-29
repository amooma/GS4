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
  
  #TODO - remove management_host. we have host now.
  #TODO - rename management_host_port to management_port
  
  before_validation(:on => :update) do
    if self.host != self.host_was || \
      self.host_port != self.host_port_was || \
      self.management_host != self.management_host_was || \
      self.management_host_port != self.management_host_port_was
      errors.add( :sip_server , "can not be changed. Please create new one!")
    end
  end
  
  before_validation do
    if self.management_host.blank? && ! self.management_host.nil?
      self.management_host = nil
    end
  end
  
  attr_accessor :last_sip_proxy_id
  
  after_create do
    if self.last_sip_proxy_id
      sip_accounts = SipAccount.where( :sip_proxy_id => last_sip_proxy_id)
      sip_accounts.each do |sip_account|
        sip_account.update_attributes(:sip_proxy_id => self.id)
      end
    end
  end
  
  # TODO tests
end
