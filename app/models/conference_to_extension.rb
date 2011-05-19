class ConferenceToExtension < ActiveRecord::Base
  belongs_to :extension, :dependent => :destroy
  belongs_to :conference
  validates_uniqueness_of :extension_id
end
