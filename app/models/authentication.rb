class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_presence_of(:user, :message => "must have a valid user")
  validates_presence_of(:provider, :message => "needed")
  validates_presence_of(:uid, :message => "needed")
end
