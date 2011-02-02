class User < ActiveRecord::Base
  has_many :sip_users, :dependent => :destroy
  
end
