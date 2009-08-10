ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  
  map.resources :home, :only=>[:index]
  
  map.resources :users
  map.resource :session

  map.namespace :analysis do |analysis|
    analysis.root :controller=>'home'
    analysis.resources :accounts, :only=>[:show,:index]
    analysis.resources :strategies
    analysis.resources :servers
    analysis.resources :three_player_profiles
    analysis.resources :game_schedulers
    analysis.resources :games do |game|
      game.resources :strategies, :controller=>'game_strategies'
    end
    analysis.resources :three_player_games
    analysis.resources :simulations, :member=> {:queue=>:any, 
                                                :fail=>:any, 
                                                :start=>:any, 
                                                :finish=>:any} do |simulation|
       simulation.resources :samples, :member=> {:process_scores=>:any}
    end
  end

  map.namespace :admin do |admin|
    admin.root :controller=>'home'
    admin.resources :accounts
    admin.resources :users do |user|
      user.resources :roles, :controller=>'user_roles'
      user.resource :password, :controller=>'user_password'
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
