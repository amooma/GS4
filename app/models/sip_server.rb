class SipServer < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  validates_presence_of      :host
  validates_uniqueness_of    :host
  validate_hostname_or_ip    :host
  
  validates_numericality_of( :port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
  validates_numericality_of( :management_port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
  validate_hostname_or_ip(   :management_host, {
    :message => "must be a valid hostname or IP address if set",
    :allow_nil   => true,
    :allow_blank => true,
  })
  # TODO tests
  validates_length_of(:management_host, :maximum => 0, :message => "must not be set if not managed by GS!", :if => Proc.new { |sip_server| ! sip_server.management_port})
  validates_length_of(:management_port, :maximum => 0, :message => "must not be set if not managed by GS!", :if => Proc.new { |sip_server| ! sip_server.management_host})
  validates_presence_of(:management_host, :message => "needed if managed by GS!", :if => Proc.new { |sip_server| sip_server.management_port })
  validates_presence_of(:management_port, :message => "needed if managed by GS!", :if => Proc.new { |sip_server| ! sip_server.management_host.blank? })
  
  before_validation(:on => :update) do
    if self.host != self.host_was || \
      self.port != self.port_was || \
      self.management_host != self.management_host_was || \
      self.management_port != self.management_port_was
      errors.add( :sip_server , "can not be changed. Please create new one!")
    end
  end
  
  before_validation do
    if self.management_host.blank? && ! self.management_host.nil?
      self.management_host = nil
    end
  end
  
  attr_accessor :last_sip_server_id
  
  after_create do
    if self.last_sip_server_id
      sip_accounts = SipAccount.where( :sip_server_id => last_sip_server_id)
      sip_accounts.each do |sip_account|
        sip_account.update_attributes(:sip_server_id => self.id)
      end
    end
    
  end
end
