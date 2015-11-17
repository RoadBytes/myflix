Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "videos#front"

  get 'forgot_password'              => 'forgot_passwords#new'
  get 'forgot_password_confirmation' => 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create] 

  resources :password_resets, only: [:show, :create]
  get 'invalid_token' => 'pages#invalid_token'

  resources :invitations, only: [:new, :create]

  get    'signin'  => 'sessions#new'
  post   'signin'  => 'sessions#create'
  delete 'signout' => 'sessions#destroy'

  get  '/home'     => 'videos#index'

  get  '/register'        => 'users#new'
  get  '/register/:token' => 'users#new_with_invitation_token', as: 'register_with_token'

  get  '/my_queue' => 'queue_items#index'
  post '/my_queue' => 'queue_items#order'

  get '/people'    => 'relationships#index'

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
