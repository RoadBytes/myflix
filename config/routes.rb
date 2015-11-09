Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get    'signin'  => 'sessions#new'
  post   'signin'  => 'sessions#create'
  delete 'signout' => 'sessions#destroy'
  
  root to: "videos#front"

  get  '/home'         => 'videos#index'
  get  '/register'     => 'users#new'

  get  '/my_queue'     => 'queue_items#index'
  post '/my_queue'     => 'queue_items#order'

  get '/people'        => 'relationships#index'

  resources :relationships, only: [:create, :destroy]

  resources :queue_items, only: [:create, :destroy]

  resources :users, only: [:show, :create]

  resources :videos, only: [:show] do 
    resources :reviews, only: [:create]

    collection do
      post :search, to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
end
