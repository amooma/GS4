class SipAccountCodec < ActiveRecord::Base
  validates_presence_of :codec_id
  validates_presence_of :sip_account_id
  validates_numericality_of :codec_id, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :sip_account_id, :only_integer => true, :greater_than_or_equal_to => 0
  
  validate :check_if_the_phone_model_offers_this_codec
  
  validates_uniqueness_of :codec_id, :scope => :sip_account_id
  
  belongs_to :sip_account
  acts_as_list :scope => :sip_account
  belongs_to :codec
  
  after_destroy :reboot_phone
  after_update :reboot_phone
  
  private
  
  # A sip_account can only uses codecs which are codecs for the phone_model 
  # of the phone.
  def check_if_the_phone_model_offers_this_codec
    phone_model = self.sip_account.phone.phone_model
    if phone_model.codecs.where(:id => self.codec_id).count == 0
      errors.add(:codec_id, "The PhoneModel #{phone_model.name} (ID #{phone_model.id}) doesn't support this codec (ID #{self.codec_id}).")
    end
  end
  
  # reboot the phone so that the configuration is up to date
  #
  def reboot_phone
    self.sip_account.phone.reboot if self.sip_account.phone.rebootable?
  end
end
