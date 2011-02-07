class PagesController < ApplicationController
	def index
		begin
			@number_of_sip_accounts = SipAccount.count
			
		#rescue
		#	redirect_to('/db_migrate_missing')
		end
	end

end
