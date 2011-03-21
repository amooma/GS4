# == Schema Information
# Schema version: 20110207214124
#
# Table name: extensions
#
#  id          :integer         not null, primary key
#  sip_user_id :integer
#  extension   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Extension < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  #FIXME ? - validate that the referenced objects exists? (sip_user)
end
