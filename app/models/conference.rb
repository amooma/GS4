class Conference < ActiveRecord::Base
  has_many :conference_to_extensions, :dependent => :destroy
  has_many :extensions, :through => :conference_to_extensions
  
  validates_uniqueness_of :uuid
  validates_presence_of :uuid
  
  validates_numericality_of :pin, :only_integer => true, :greater_than_or_equal_to => 0
  #OPTIMIZE Fix the PIN validation. Make the database column a string instead of an integer.
  # This doesn't let you use PINs that start with "0" (except for 0 itself).
  #validates_format_of :pin, :with => /^[0-9]+$/, :allow_blank => true, :allow_nil => true
  
  validate_username :uuid
  # OPTIMIZE :uuid length = "-conference-" + 10
  validates_format_of :uuid, :with => /^-conference-.*$/,
    :allow_nil => false, :allow_blank => false
end
