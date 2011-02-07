class Extension < ActiveRecord::Base
  has_many :sip_accounts, :dependent => :destroy
end
