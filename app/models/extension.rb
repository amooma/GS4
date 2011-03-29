class Extension < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
  
  # TODO Should this model be for other numbers as well?
end
