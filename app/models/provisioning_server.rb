class ProvisioningServer < ActiveRecord::Base
  
  has_many :sip_phones, :dependent => :destroy
  
  validates_presence_of :name
  validates_presence_of :port
  validates_numericality_of( :port,
    :greater_than =>     0,
    :less_than    => 65536
  )
  validate_hostname_or_ip :name
  validates_uniqueness_of :name
  
end
