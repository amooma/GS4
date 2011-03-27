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
  after_validation( :on => :update) do
    if self.management_host != self.management_host_was
      errors.add( :management_host, "can NOT be changed! Please delete server and create new one.")
    end
  end
end
