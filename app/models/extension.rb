class Extension < ActiveRecord::Base
  
  #OPTIMIZE extension must be a string (instead of an integer).
  
  has_many :sip_account_to_extensions, :dependent => :destroy
  has_many :sip_accounts, :through => :sip_account_to_extensions
  
  validates_inclusion_of  :active, :in => [ true, false ], :allow_nil => false
  
  validates_presence_of   :extension
  validates_uniqueness_of :extension, :scope => :active, :if => Proc.new{|me| me.active}
  
  
end
