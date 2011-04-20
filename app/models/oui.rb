class Oui < ActiveRecord::Base
  validates_presence_of :value
  validates_uniqueness_of :value
  validates_length_of :value, :is => 6
  validates_format_of :value, :with => /^[0-9A-F]{6}$/
  
  validate :does_a_manufacturer_to_this_phone_model_exist
  
  belongs_to :manufacturer
  
  private

  # Validates if a manufacturer to the phone model exists.
  def does_a_manufacturer_to_this_phone_model_exist
    if ! Manufacturer.exists?(:id => self.manufacturer_id)
      errors.add(:manufacturer_id, "There is no Manufacturer with the given id #{self.manufacturer_id}.")
    end      
  end
end
