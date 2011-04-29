class Extension < ActiveRecord::Base
  
  has_many :sip_account_to_extensions, :dependent => :destroy
  has_many :sip_accounts, :through => :sip_account_to_extensions
  
  validates_inclusion_of :active, :in => [ true, false ], :allow_nil => false
  validates_uniqueness_of :extension, :scope => :active, :if => Proc.new{|me| me.active}
  
end
