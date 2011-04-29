# This serves as a base class for SipServer, SipProxy, VoicemailServer.
#
class AServer < ActiveRecord::Base
  
  self.abstract_class = true
  
  before_validation( :on => :update ) {
    if self.host            != self.host_was \
    || self.port            != self.port_was
      errors.add( :base , "#{self.class.to_s} cannot be changed. Please create a new one." )
    end
  }
  
  validates_presence_of     :host
  validate_hostname_or_ip   :host
  validates_uniqueness_of   :host, :case_sensitive => false, :scope => :port
  
  validate_ip_port          :port, :allow_nil => true  # empty SIP port means default SIP port (SRV lookups)
  validates_uniqueness_of   :port, :scope => :host
  
  validates_inclusion_of    :is_local, :in => [ true, false ], :allow_nil => false
  validates_uniqueness_of   :is_local, :if => Proc.new { |me| me.is_local }  #OPTIMIZE Edit once domains are implemented.
  
end
