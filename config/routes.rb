Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home', to: 'pages#home'
  get '/signup', to: 'users#new'
  get '/chat', to: 'chatrooms#show'

  resources :users, except: [:new]
  
  resources :recipes do
    resources :comments, only: [:create]
  end
  
  resources :ingredients, except: [:destroy]
  resources :messages, only: [:create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  mount ActionCable.server => '/cable'
end
