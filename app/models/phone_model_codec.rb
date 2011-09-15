class PhoneModelCodec < ActiveRecord::Base
  
  belongs_to :phone_model
  belongs_to :codec
  
  acts_as_list :scope => :phone_model
  
  validates_uniqueness_of :codec_id, :scope => :phone_model_id
  
  #OPTIMIZE Remove custom messages or add translations.
  validates_presence_of(:phone_model_id, :message => "Need phone_model_id")
  validates_numericality_of(:phone_model_id, :message => "Only integer allowed as phone_model_id")
  validates_presence_of(:codec_id, :message => "Need codec_id")
  validates_numericality_of(:codec_id, :message => "Only integer allowes as codec_id")
  validate :codec_exists
  
  private
  
  def codec_exists
    if !Codec.all.collect {|c| c.id}.include? self.codec_id
      errors.add(:codec_id, "#{self.codec_id} is not a valid codec_id")
    end
  end
  
end
