Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get    'signin'  => 'sessions#new'
  post   'signin'  => 'sessions#create'
  delete 'signout' => 'sessions#destroy'
  
  root to: "videos#front"

  get    '/home'         => 'videos#index'
  get    '/register'     => 'users#new'
  get    '/my_queue'     => 'queue_items#index'
  delete '/my_queue/:id' => 'queue_items#destroy'

  resources :users, only: [:create]

  resources :videos, only: [:show] do 
    resources :reviews, only: [:create]

    collection do
      post :search, to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
end
