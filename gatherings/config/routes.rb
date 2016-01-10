Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome', to: 'welcome#index', as: :welcome

  get "welcome/sign_up", to: "welcome#sequence_begin_step", as: :welcome_signup
  get "welcome/sign_up(/:id)", to: "welcome#sequence_begin_step", as: :welcome_signup_step
  patch "welcome/sign_up(/:id)", to: "welcome#sequence_complete_step", as: :welcome_complete_signup_step

  devise_scope :member do
    get '/sign_up', to: 'members/registrations#sequence_begin_step', as: :new_member_registration
    get "/sign_up(/:id)", to: "members/registrations#sequence_begin_step", as: :member_signup_step
    patch "/sign_up(/:id)", to: "members/registrations#sequence_complete_step", as: :member_complete_signup_step
  end

  devise_for :members, controllers: {
    registrations: 'members/registrations',
    sessions: 'members/sessions'
  }
  # resources :members
  get 'communities', to: 'communities#index', as: :member_root

  resources :communities do
    get 'gatherings/:mode(/:id)', to: "gatherings#sequence_begin_step", as: :gathering_step, constraints: {mode: /create|edit/}
    patch 'gatherings/:mode(/:id)', to: "gatherings#sequence_complete_step", as: :gathering_complete_step, constraints: {mode: /create|edit/}

    get 'report', to: "communities#report", as: :report

    resources :gatherings, only: [:index, :show, :destroy]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
