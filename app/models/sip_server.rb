# == Schema Information
# Schema version: 20110207214124
#
# Table name: sip_servers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SipServer < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  validates_presence_of(:name, :message => ":name missing")
  validates_uniqueness_of(:name, :message => "Server already exists")
  validate_hostname_or_ip(:name)
end
