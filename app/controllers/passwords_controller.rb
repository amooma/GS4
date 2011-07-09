class PasswordsController < Devise::PasswordsController
	
	prepend_view_path "app/views/devise"  # use default Devise views
	
	# https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
	authorize_resource :class => :Password
	
end
