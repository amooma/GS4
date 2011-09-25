class LdapImportSession
  # http://railscasts.com/episodes/219-active-model
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming  

  attr_accessor :host, :version, :ssl, :port, :bind_dn, :password, :base_dn, :cn 
   
  validates_presence_of :host
  validates_numericality_of :version, :only_integer => true, :greater_than_or_equal_to => 2, :less_than_or_equal_to => 3
  validates :ssl, :inclusion => {:in => [true, false]}
  validates_numericality_of :version, :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 65000
    
  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end  
    
  def persisted?  
    false  
  end
end
