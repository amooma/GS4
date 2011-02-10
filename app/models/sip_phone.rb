# == Schema Information
# Schema version: 20110207214124
#
# Table name: sip_phones
#
#  id                     :integer         not null, primary key
#  phone_id               :integer
#  provisioning_server_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class SipPhone < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  has_one :provisioning_server, :validate => true
  
  validates_presence_of :provisioning_server
end
