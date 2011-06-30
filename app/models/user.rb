class User < ActiveRecord::Base
  
  has_many :authentications  
  
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
  
  validates_presence_of(   :username, :message =>  I18n.t(:needed))
  validates_uniqueness_of( :username, :case_sensitive => false, :message => I18n.t(:already_taken))
  validate_username(       :username )
  
end
