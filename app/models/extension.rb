class Extension < ActiveRecord::Base
  
  #OPTIMIZE extension must be a string (instead of an integer).
  
  has_many :sip_account_to_extensions, :dependent => :destroy
  has_many :sip_accounts, :through => :sip_account_to_extensions
  has_many :conference_to_extensions, :dependent => :destroy
  has_many :conferences, :through => :conference_to_extensions
  
  validates_inclusion_of  :active, :in => [ true, false ], :allow_nil => false
  
  # Extension must not be nil or blank:
  validates_presence_of   :extension
  # Extension must be a valid SIP "user" per RFC 3261:
  validate_username       :extension
  # Extension must have a format that we support:
  validates_format_of     :extension, :with => /^[a-zA-Z0-9+*#][a-zA-Z0-9+*#.\-_]*$/,
    :allow_nil => false, :allow_blank => false
  # Active extensions must be unique:
  validates_uniqueness_of :extension, :scope => :active, :if => Proc.new{|me| me.active}
  
  #OPTIMIZE Do not allow "anonymous" as an extension. It is reserved. (RFC 2543, RFC 3325)
  # And add a test that makes sure "anonymous" is invalid.
  
  # Destination must not be nil or blank:
  validates_presence_of   :destination
  # Destination must be a valid SIP "user" per RFC 3261:
  validate_username       :destination
  # Destination must have a destination that we support:
  validates_format_of     :destination, :with => /^[a-zA-Z0-9+*#\-][a-zA-Z0-9+*#.\-_]*$/,
    :allow_nil => false, :allow_blank => false
end

