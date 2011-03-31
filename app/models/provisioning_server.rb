class ProvisioningServer < ActiveRecord::Base
  
  has_many :sip_phones, :dependent => :destroy
  
  validates_presence_of     :name
  validate_hostname_or_ip   :name
  validates_uniqueness_of   :name
  
  validates_presence_of     :port
  validate_ip_port          :port
  
end
