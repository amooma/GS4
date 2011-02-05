class UserToPhone < ActiveRecord::Base
  has_many :users
  validates_numericality_of(:user_id, :message => "User_id must be a number")
  validates_numericality_of(:phone_id, :message => "phone_id must be a number")
  validates_presence_of(:phone_id, :message => "phone_id needed")
  validates_presence_of(:user_id, :message => "user_id needed")
end
