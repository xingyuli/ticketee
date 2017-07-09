Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'projects#index'

  resources :projects do
    resources :tickets
  end

  resources :users

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'

end
