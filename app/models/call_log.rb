class CallLog < ActiveRecord::Base
  belongs_to :sip_account, :validate => true
end
