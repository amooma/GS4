Gemeinschaft4::Application.routes.draw do
	
	get "setup/index"
	get "setup/create"
	get "setup/new"
	
	match '/auth/:provider/callback' => 'authentications#create'
	resources :authentications      , :only => [ :index, :create, :destroy ]
	
	devise_for :users
	
	resources :sip_accounts
	resources :provisioning_servers
	resources :sip_phones
	resources :sip_servers          , :only => [ :index, :show, :new, :create, :destroy ]
	resources :sip_proxies          , :only => [ :index, :show, :new, :create, :destroy ]
	resources :voicemail_servers
	resources :extensions
	
	resources :admin                , :only => [ :index ]
	
	resources :kamailio             , :only => [ :index ], :format => 'txt'
	
	match '/freeswitch-directory-entries/search',
		:via        => [ :get, :post ],
		:controller => :freeswitch_directory_entries,
		:action     => 'search',
		:format     => :'xml'
	
	match '/freeswitch-call-processing/actions',
		:via        => [ :get, :post ],
		:controller => :freeswitch_call_processing,
		:action     => 'actions',
		:format     => :'xml'
	
	namespace :admin do
		resources :users
		resources :setup
	end
	
	# The priority is based upon order of creation:
	# first created -> highest priority.
	
	# Sample of regular route:
	#	match 'products/:id' => 'catalog#view'
	# Keep in mind you can assign values other than :controller and :action
	
	# Sample of named route:
	#	match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
	# This route can be invoked with purchase_url(:id => product.id)
	
	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#	resources :products
	
	# Sample resource route with options:
	#resources :products do
	#	member do
	#		get 'short'
	#		post 'toggle'
	#	end
	#	
	#	collection do
	#		get 'sold'
	#	end
	#end
	
	# Sample resource route with sub-resources:
	#resources :products do
	#	resources :comments, :sales
	#	resource :seller
	#end
	
	# Sample resource route with more complex sub-resources
	#resources :products do
	#	resources :comments
	#	resources :sales do
	#		get 'recent', :on => :collection
	#	end
	#end
	
	# Sample resource route within a namespace:
	#namespace :admin do
	#	# Directs /admin/products/* to Admin::ProductsController
	#	# (app/controllers/admin/products_controller.rb)
	#	resources :products
	#end
	
	# You can have the root of your site routed with "root"
	# just remember to delete public/index.html.
	# root :to => "welcome#index"
	
	root :to => 'admin#index'
	
	
	# See how all your routes lay out with "rake routes"
	
	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id(.:format)))'
end
