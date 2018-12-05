Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home', to: 'pages#home'

  get '/signup', to: 'users#new'
  resources :users, except: [:new]
  resources :recipes
end
