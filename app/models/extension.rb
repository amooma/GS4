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
  
  after_save( :on => :create ) {
    if (! self.destination.blank?)
      create_sip_account_relation()
    end
  }	
  
  after_save( :on => :update ) {
    if (! self.destination.blank?) && (! self.destination_was.blank?)
      update_sip_account_relation()
    end
  }  
  
  def create_sip_account_relation()
    sip_account = SipAccount.find_by_auth_name( self.destination )
    if (! sip_account.nil?)
       sip_account_extension = SipAccountToExtension.create(
         :sip_account_id => sip_account.id,
         :extension_id => self.id
       )
    end
  end
  
  def update_sip_account_relation()
    sip_account_extension = SipAccountToExtension.find_by_extension_id( self.id )
    sip_account = SipAccount.find_by_auth_name( self.destination )
    if (sip_account.nil?)
      if (! sip_account_extension.destroy)
        errors.add( :base, "Failed to delete sip account extension")
      end
    else
      sip_account_extension_update = sip_account_extension.update_attributes(
        :sip_account_id => sip_account.id   
      )
      if (! sip_account_extension_update)
        errors.add( :base, "Failed to update sip account extension")
      end
    end
  end 
end

