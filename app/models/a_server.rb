# This serves as a base class for SipServer, SipProxy, VoicemailServer.
#
class AServer < ActiveRecord::Base
  
  self.abstract_class = true
  
  before_validation( :on => :update ) {
    if self.host            != self.host_was \
    || self.port            != self.port_was \
    || self.management_host != self.management_host_was \
    || self.management_port != self.management_port_was
      errors.add( :base , "#{self.class.to_s} cannot be changed. Please create a new one." )
    end
  }
  
  before_validation {
    # make sure management_host is nil (instead of "")
    if self.management_host.blank? && ! self.management_host.nil?
      self.management_host = nil
    end
  }
  
  validates_presence_of     :host
  validate_hostname_or_ip   :host
  validates_uniqueness_of   :host, :case_sensitive => false, :scope => :port
  validates_uniqueness_of   :port, :scope => :host
  
  validate_ip_port          :port, :allow_nil => true  # empty SIP port means default SIP port (SRV lookups)
  
  validates_presence_of     :management_host, {
    :message => "must be present if a management port is set.",
    :if => Proc.new { |me| ! me.management_port.blank? },
  }
  validate_hostname_or_ip   :management_host, {
    :message => "must be a valid hostname or IP address if set.",
    :allow_nil   => true,
    :allow_blank => true,
  }
  validates_uniqueness_of   :management_host,
    :allow_nil   => true,
    :allow_blank => true
  #validates_uniqueness_of   :management_port, :scope => :management_host
  
  validate_ip_port          :management_port, :allow_nil => true
  validates_presence_of     :management_port, {
    :message => "must be present if a management host is set.",
    :if => Proc.new { |me| ! me.management_host.blank? },
  }
  
end
