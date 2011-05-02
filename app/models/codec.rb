class Codec < ActiveRecord::Base
  
  validates_presence_of   :name
  validates_format_of     :name, :with => /^[a-zA-Z0-9.\-_]{1,40}$/,
    :allow_nil => false, :allow_blank => false
  validates_uniqueness_of :name
  
  has_many :sip_account_codecs, :dependent => :destroy
  has_many :sip_accounts, :through => :sip_account_codecs
  
  has_many :phone_model_codecs, :dependent => :destroy
  has_many :phone_models, :through => :phone_model_codecs
  
  before_validation :downcase_codec_name
  
  private
  def downcase_codec_name
    self.name = self.name.downcase if ! self.name.blank?
  end
  
end
