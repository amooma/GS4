class PersonalPhonebook < ActiveRecord::Base
  belongs_to :user, :validate => true
  validates_presence_of :user
end
