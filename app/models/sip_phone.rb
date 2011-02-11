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
  belongs_to :provisioning_server, :validate => true
  
  # The provisioning server must never change, once it has been set.
  validate {
    if provisioning_server_id_was != nil \
    && provisioning_server_id != provisioning_server_id_was
      errors.add( :provisioning_server_id, "must not change. You have to delete the SIP phone and create it on the other provisioning server." )
    end
  }
  
  # The phone_id must never change, once it has been set.
  validate {
    if phone_id_was != nil \
    && phone_id != phone_id_was
      errors.add( :phone_id, "must not change. You have to delete the SIP phone and create a new one." )
    end
  }
  
  # If the phone does not belong to a provisioning server then the
  # phone_id has to be nil.
  validate {
    if provisioning_server_id.blank? && (! phone_id.blank?)
      errors.add( :phone_id, "must be blank if the phone does not belong to a provisioning server." )
    end
  }
  
  
end
