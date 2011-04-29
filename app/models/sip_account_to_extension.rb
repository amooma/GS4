class SipAccountToExtension < ActiveRecord::Base
  belongs_to :sip_account
  belongs_to :extension
  validates_presence_of :sip_account
  validates_presence_of :extension
  acts_as_list :scope => :sip_account
  validates_uniqueness_of :extension_id
end
