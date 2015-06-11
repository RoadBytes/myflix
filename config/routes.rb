Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  
  root to: "videos#index"
  get '/home' => 'videos#index'

  resources :videos, only: [:show] do 
    collection do
      post :search, to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
end
