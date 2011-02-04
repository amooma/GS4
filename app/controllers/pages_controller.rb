class PagesController < ApplicationController
	def index
		begin
			@number_of_users = User.count
			
		#rescue
		#	redirect_to('/db_migrate_missing')
		end
	end

end
