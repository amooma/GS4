# == Schema Information
# Schema version: 20110207214124
#
# Table name: provisioning_servers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  port       :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProvisioningServer < ActiveRecord::Base
  
  has_many :sip_phones
  
  validates_presence_of :name
  validates_presence_of(:port, :message => "Port needed")
  validates_numericality_of( :port, :message => "Must be integer",
    :greater_than => 0,
    :less_than => 65536,
  )
  validate_hostname_or_ip :name
  validates_uniqueness_of(:name, :message => "already exists")
  
end
