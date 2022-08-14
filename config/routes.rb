Rails.application.routes.draw do
  devise_for :users  do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :convert_images, only: [:new, :create, :index]
  root to: "home#index"
end
