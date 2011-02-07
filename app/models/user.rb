class User < ActiveRecord::Base
  has_many :authentications  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable, :registerable and :activatable
  devise :database_authenticatable,  
         :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :gn, :sn
  has_many :sip_accounts
  
  validates_presence_of(:username, :message => "username needed")
  validates_uniqueness_of(:username, :message => "username allready taken")
  # TODO Validations
  # TODO Tests
  #TODO Create Method and View to create new users
end
