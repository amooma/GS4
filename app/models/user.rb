class User < ActiveRecord::Base
  
  ROLES = {
    "user"  => I18n::t( :role_user ),
    "admin" => I18n::t( :role_admin ),
    "cdr"   => I18n::t( :role_cdr ),
  }
  
  has_many :authentications
  has_many :personal_contacts, :dependent => :destroy
  has_many :conferences, :dependent => :destroy
  has_many :fax_documents, :dependent => :destroy
  has_many :user_to_extensions, :dependent => :destroy
  has_many :extensions, :through => :user_to_extensions
  has_many :dialplan_routes, :dependent => :destroy
  has_many :sip_accounts
  has_many :phones, :through => :sip_accounts
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable, :registerable, :recoverable, :rememberable and :activatable
  devise(
    :database_authenticatable,  
    :trackable,
    :validatable
  )
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :gn, :sn, :username, :role
  
  validates_presence_of    :username
  validates_uniqueness_of  :username, :case_sensitive => false
  validate_username        :username
  
  validates_presence_of    :password
  validates_presence_of    :password_confirmation
  
  validates_presence_of    :role
  validates_inclusion_of   :role, :in => self::ROLES.keys
  
  before_validation( :on => :update ) {
    if self.role != self.role_was
      errors.add( :role , "cannot be changed." )
    end
  }
  
  validates_uniqueness_of  :role,
    :if => Proc.new { |user| user.role == "cdr" },
    :message => "must not be CDR for more than one user."
  
  
  def to_display
    ret = I18n.t( :user_to_display_improved, {
      :id          => self.id,
      :username    => self.username,
      :email       => self.email,
      :full_name   => "#{self.gn.to_s.strip} #{self.sn.to_s.strip}" .strip,
      :role        => self.role,
    }).to_s
    ret.strip!
    return ret
  end
  
end
