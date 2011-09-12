class PhoneModelKey < ActiveRecord::Base
  
  belongs_to :phone_model, :validate => true
  has_many :phone_key_to_function_mappings
  has_many :phone_key_function_definitions, :through => :phone_key_to_function_mappings
  has_many :phone_keys, :dependent => :destroy
  
  validates_presence_of     :phone_model_id
  validates_numericality_of :phone_model_id, :only_integer => true
  
  validates_uniqueness_of :name, :scope => :phone_model_id
  
end
