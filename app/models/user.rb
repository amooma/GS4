class User < ActiveRecord::Base
  

  ROLES = {
    "user"  => I18n::t( :role_user ),
    "admin" => I18n::t( :role_admin ),
    "cdr"   => I18n::t( :role_cdr ),
  }

  has_many :authentications
  has_many :personal_contacts, :dependent => :destroy
  has_many :conferences, :dependent => :destroy
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable, :registerable and :activatable
  devise(
    :database_authenticatable,  
    :recoverable,
    :rememberable,
    :trackable,
    :validatable
  )
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :gn, :sn, :username, :role
  
  has_many :sip_accounts
  
  validates_presence_of    :username
  validates_uniqueness_of  :username, :case_sensitive => false
  validate_username        :username
  
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
  
end
