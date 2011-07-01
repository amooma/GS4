class User < ActiveRecord::Base
  
  has_many :authentications
  has_many :personal_phonebooks, :dependent => :destroy
  
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
  attr_accessible :email, :password, :password_confirmation, :gn, :sn, :username
  
  has_many :sip_accounts
  
  validates_presence_of(   :username, :message => "needed" )
  validates_uniqueness_of( :username, :case_sensitive => false, :message => "already taken" )
  validate_username(       :username )
  
end
