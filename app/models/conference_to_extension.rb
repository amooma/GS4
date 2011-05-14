class ConferenceToExtension < ActiveRecord::Base
  belongs_to :extension
  belongs_to :conference
end
