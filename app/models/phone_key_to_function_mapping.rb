class PhoneKeyToFunctionMapping < ActiveRecord::Base
  belongs_to :phone_key_function_definition
  belongs_to :phone_model_key
  
  validates_numericality_of :phone_model_key_id,
    :only_integer => true,
    :allow_nil => false,
    :allow_blank => false
  validate :validate_phone_model_key
  
  validates_numericality_of :phone_key_function_definition_id,
    :only_integer => true,
    :allow_nil => false,
    :allow_blank => false
  validate :validate_phone_key_function_definition
  
  private
  
  # Checks if the phone_model_key exists.
  def validate_phone_model_key()
    if ! PhoneModelKey.exists?( :id => self.phone_model_key_id )
      errors.add( :phone_model_key_id, "is invalid.")
    end
  end
  
  # Checks if the phone_key_function_definition exists.
  def validate_phone_key_function_definition()
    if ! PhoneKeyFunctionDefinition.exists?( :id => self.phone_key_function_definition_id )
      errors.add( :phone_key_function_definition_id, "is invalid.")
    end
  end
  
end
