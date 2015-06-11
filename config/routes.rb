Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  
  get '/home' => 'videos#index'
  resources :videos, only: [:index, :show]

  get '/search' => 'videos#search', as: :search

  resources :categories, only: [:show]
end
