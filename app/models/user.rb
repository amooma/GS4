# == Schema Information
# Schema version: 20110207214124
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  username             :string(255)
#  sn                   :string(255)
#  gn                   :string(255)
#

class User < ActiveRecord::Base
  
  has_many :authentications  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :confirmable, :timeoutable, :registerable and :activatable
  devise :database_authenticatable,  
         :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :gn, :sn, :username
  
  has_many :sip_accounts
  
  validates_presence_of(   :username, :message => "username needed" )
  validates_uniqueness_of( :username, :message => "username already taken" )
  
  # TODO Validation for username rest is validated (:validatable)
  
end
