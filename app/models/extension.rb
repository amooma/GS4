class Extension < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  # OPTIMIZE Should this model be for other numbers as well?
end
