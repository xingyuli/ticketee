Rails.application.routes.draw do
  namespace :admin do
    root to: 'base#index'
    resources :users do
      resources :permissions

      put 'permissions', to: 'permissions#set',
                         as: 'set_permissions'
    end
    resources :states do
      member do
        get :make_default
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'projects#index'

  resources :projects do
    resources :tickets
  end

  resources :tickets do
    resources :comments
  end

  resources :users

  resources :files

  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

end
