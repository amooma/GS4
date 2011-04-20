class PhoneModelMacAddress < ActiveRecord::Base
  validates_presence_of :starts_with
  validates_uniqueness_of :starts_with
  validates_length_of :starts_with, :within => 1..12
  validates_format_of :starts_with, :with => /^[0-9A-F]+$/
  belongs_to :phone_model
end
