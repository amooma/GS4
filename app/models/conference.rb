class Conference < ActiveRecord::Base
  has_many :conference_to_extensions, :dependent => :destroy
  has_many :extensions, :through => :conference_to_extensions
  
  validates_uniqueness_of :uuid
  validates_presence_of :uuid
  validates_numericality_of :pin
  
  validate_username :uuid
  # OPTIMIZE :uuid length = "-conference-" + 10
  validates_format_of :uuid, :with => /^-conference-.*$/,
    :allow_nil => false, :allow_blank => false
end
