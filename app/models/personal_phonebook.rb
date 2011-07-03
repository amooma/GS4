class PersonalPhonebook < ActiveRecord::Base
  #OPTIMIZE Looks like this should rather be called PersonalPhonebookEntries.
  belongs_to :user, :validate => true
  validates_presence_of :user
end
