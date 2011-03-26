class Extension < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  #FIXME ? - validate that the referenced objects exists? (sip_user)
end
