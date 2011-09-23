class CallLog < ActiveRecord::Base
	belongs_to :sip_account, :validate => true
  
	def self.delete_old
		call_log_keep_days = Configuration.get( :call_log_keep_days, 32, Integer )
		old_entries = self.where( :updated_at => Time.zone.at(0)..Time.zone.at(Time.now.advance( :days => ( call_log_keep_days * -1 ) ) ) )
		return self.delete(old_entries)
	end
	
end
