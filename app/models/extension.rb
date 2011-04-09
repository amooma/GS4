class Extension < ActiveRecord::Base
  
  has_many :sip_accounts, :dependent => :destroy
  
  # OPTIMIZE Use this as an index / lookup table for all kinds of
  # extensions, not just extensions of SIP accounts.
  
end
