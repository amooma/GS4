class PagesController < ApplicationController
	
	#before_filter :authenticate_user!
	
	def index
		begin
			if User.count == 0 || SipServer.count == 0 || ProvisioningServer.count == 0
				respond_to do |format|
					format.html { redirect_to(admin_setup_index_path) }
				end
			end
			rescue
				redirect_to('/db_migrate_missing')
		end
	end
	
end
