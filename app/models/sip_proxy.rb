class SipProxy < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  validates_presence_of      :name
  validates_uniqueness_of    :name
  validate_hostname_or_ip    :name
  validates_numericality_of( :config_port,
    :allow_nil    => true,
    :greater_than =>     0,
    :less_than    => 65536,
  )
  
  # TODO tests
  validates_inclusion_of(:managed_by_gs, :in => [true, false], :message => "must be true or false!")
  validates_length_of(:config_port, :maximum => 0, :message => "must not be set if not managed by GS!", :if => Proc.new { |sip_server| ! sip_server.managed_by_gs})
  validates_presence_of(:config_port, :message => "needed if managed by GS!", :if => Proc.new { |sip_server| sip_server.managed_by_gs })
  after_validation( :on => :update) do
    if self.managed_by_gs != self.managed_by_gs_was
      errors.add( :managed_by_gs, "can NOT be changed! Please delete server and create new one.")
    end
  end
end
