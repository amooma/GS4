class Authentication < ActiveRecord::Base
  belongs_to :user
  #FIXME - validate that the referenced objects exists (user)
end
