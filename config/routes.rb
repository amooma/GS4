Gemeinschaft4::Application.routes.draw do
	
  	resources :ldap_import_sessions

	resources :network_settings
	
	resources :configurations
	
	resources :global_contacts do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :personal_contacts do
		member do
			get 'confirm_destroy'
		end
	end
		
	resources :call_logs do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :call_queues do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :call_forwards do  #OPTIMIZE Nest this inside sip_accounts and adjust the views accordingly.
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :conferences do
		member do
			get 'confirm_destroy'
		end
	end
	
	get "setup/index"  #OPTIMIZE Is this route being used?
	get "setup/create"  #OPTIMIZE Is this route being used?
	get "setup/new"  #OPTIMIZE Is this route being used?
	
	match '/auth/:provider/callback' => 'authentications#create'
	resources :authentications      , :only => [ :index, :create, :destroy ]
	
	devise_for :users, :controllers => {
		:sessions   => 'devise/sessions',
		:passwords  => 'passwords',
	}
	
	resources :sip_accounts do
		resources :extensions
	end
	resources :conferences do
		resources :extensions
	end
	resources :call_queues do
		resources :extensions
	end
	resources :backups, :only => [ :index, :create, :update, :show, :destroy, :new ]
	
	resources :sip_servers          , :only => [ :index, :show, :new, :create, :destroy ] do
		member do
			get 'confirm_destroy'
		end
	end
	resources :sip_proxies          , :only => [ :index, :show, :new, :create, :destroy ] do
		member do
			get 'confirm_destroy'
		end
	end
	resources :nodes                , :only => [ :index, :show ] # for now
	# Remember to comment-in the tests in test/functional/nodes_controller_test.rb
	# once you enable more routes for the nodes.
	resources :voicemail_servers do
		member do
			get 'confirm_destroy'
		end
	end	
	
	resources :extensions do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :admin                , :only => [ :index ]
	resources :cdrs                 , :only => [ :index ]
	resources :kamailio             , :only => [ :index ], :format => 'txt'  #OPTIMIZE Is this route being used?
  
  match '/help',
		:via        => [ :get ],
		:controller => :home,
		:action     => 'help'

	match '/admin/help',
		:via        => [ :get ],
		:controller => :admin,
		:action     => 'help'
	
	#OPTIMIZE Shutdown shouldn't be GET but POST. HTTP semantics.
	match '/admin/shutdown',
		:via        => [ :get ],
		:controller => :admin,
		:action     => :shutdown
	
	#OPTIMIZE Reboot shouldn't be GET but POST. HTTP semantics.
	match '/admin/reboot',
		:via        => [ :get ],
		:controller => :admin,
		:action     => :reboot
	
	match '/admin/confirm_reboot',
		:via        => [ :get ],
		:controller => :admin,
		:action     => :confirm_reboot
	
	match '/admin/confirm_shutdown',
		:via        => [ :get ],
		:controller => :admin,
		:action     => :confirm_shutdown
	
	match '/freeswitch-directory-entries/search',
		:via        => [ :get, :post ],
		:controller => :freeswitch_directory_entries,
		:action     => 'search',
		:format     => :'xml'
	
	match '/freeswitch-call-processing/actions((.:subfmt).:format)',
		:via        => [ :get, :post ],
		:controller => :freeswitch_call_processing,
		:action     => 'actions',
		:defaults    => { :format => :'xml', :subfmt => nil },
		:constraints => { :format => /[a-z0-9]+/, :subfmt => /[a-z0-9]+/ }
	
	match '/freeswitch-configuration/freeswitch',
		:via        => [ :get, :post ],
		:controller => :freeswitch_configuration,
		:action     => 'load',
		:format     => :'xml'
	
	resources :dialplan_routes, :path => 'dialplan-routes' do
		member do
			post :move_up
			post :move_down
			post :move_to_top
			post :move_to_bottom
			get 'confirm_destroy'
		end
		collection do
			get  :test
			post :test
		end
	end
	
	resources :dialplan_patterns, :path => 'dialplan-patterns' do
		member do
			get 'confirm_destroy'
		end
	end
	
	namespace :admin do
		resources :wizard_phone_and_user, :only => [:new, :create]
		resources :users do
			member do
				get 'confirm_destroy'
			end
		end
		resources :setup  #OPTIMIZE Do we need a full resource or just an index?
	end
	
	match '/admin/mail_configuration',
		:via        => [ :get ],
		:controller => 'admin/mail_configuration',
		:action     => :edit
	
	match '/admin/mail_configuration',
		:via        => [ :post ],
		:controller => 'admin/mail_configuration',
		:action     => :create
	
	match '/admin/mail_configuration/show',
		:via        => [ :get ],
		:controller => 'admin/mail_configuration',
		:action     => :show
	
	# Cantina
	resources :reboot_requests, :only => [:index, :show, :create, :new ]  #OPTIMIZE Is this route being used?
	
	resources :manufacturer_snom    , :only => [ :index ]
	resources :manufacturer_aastra  , :only => [ :index ]  #OPTIMIZE Is this route being used?
	resources :manufacturer_tiptel  , :only => [ :index ]  #OPTIMIZE Is this route being used?
	
	match '/manufacturer_snom/:mac_address/:action',
		:via        => [ :get, :post ],
		:controller => :manufacturer_snom,
		:format     => :'xml'
	
	match '/manufacturer_snom/:mac_address/:sip_account/:action',
		:via        => [ :get, :post ],
		:controller => :manufacturer_snom,
		:format     => :'xml'
	
	match 'settings-:mac_address' => 'manufacturer_snom#show',
		:format => 'xml',
		:constraints => { :mac_address => /000413.*/ }
	
	match 'freeswitch-missed-call-:uuid' => 'freeswitch_call_log#set_missed_call'
	resources :freeswitch_call_log    , :only => [ :set_missed_call ]
	
	resources :provisioning_log_entries, :only => [ :index, :show ]  #OPTIMIZE Is this route being used?
	resources :phone_model_mac_addresses  #OPTIMIZE Is this route being used?
	match 'phones/:id/reboot' => 'phones#reboot', :as => :phone_reboot
	
	# http://guides.rubyonrails.org/routing.html#nested-resources
	
	resources :phones do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :phones do
		resources :sip_accounts  #OPTIMIZE Is it still useful to nest sip_accounts in phones?
	end
	
	resources :sip_accounts do
		resources :phone_keys  #OPTIMIZE Is this route being used?
	end
	
	resources :sip_accounts do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :codecs  #OPTIMIZE Is this route being used?
	
	resources :sip_account_codecs  #OPTIMIZE Is this route being used?
	
	resources :phone_key_function_definitions  #OPTIMIZE Is this route being used?
	
	resources :phone_model_keys  #OPTIMIZE Is this route being used?
	
	resources :manufacturers do
		resources :phone_models
	end
	
	resources :phone_models do
		resources :phones
	end
	
	resources :fax_documents do
		member do
			get 'confirm_destroy'
			get 'number'
			put 'transfer'
			post 'update'
		end
	end
	
	resources :voicemails do
		member do
			get 'confirm_destroy'
		end
	end
	
	resources :sip_gateways, :path => 'gateways' do
		member do
			get 'confirm_destroy'
		end
	end
	
	match 'pin_change',
		:via        => [ :get ],
		:controller => :pin_change,
		:action     => :edit
	
	match 'pin_change',
		:via        => [ :post ],
		:controller => :pin_change,
		:action     => :update
	
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
	
	root :to => 'home#index'
	
	# See how all your routes lay out with "rake routes"
	
	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	# match ':controller(/:action(/:id(.:format)))'
end
