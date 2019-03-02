Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products
  resources :users do
    member do
      get '/:id/upgrade' => :upgrade, as: :upgrate
      get :logout
      patch :edit_user_role
      patch :update_user_role
    end
  end
  get '/login' => "users#login", as: :login_user
  post '/create_session' => "users#create_session", as: :create_user_session

  root "products#index"
end
