Myflix::Application.routes.draw do
  root to: 'pages#front' # 'videos#index'

  resources :videos, only: [:show, :index] do
    collection do    
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end 

  namespace :admin do
    resources :videos, only: [:new, :create]
  end  

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: "videos#index"
  get 'register', to: "users#new"
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  get 'sign_in', to: "sessions#new"
  post 'sign_in', to: 'sessions#create'
  get  'sign_out', to: 'sessions#destory'
  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  resources :queue_items, only: [:index, :create, :destroy]
  post 'update_queue', to: "queue_items#update_queue"

  get 'forgot_password', to: "forgot_passwords#new" 
  resources :forgot_passwords, only:[:create]
  get 'forgot_password_confirmation', to: "forgot_passwords#confirm"   
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: "pages#expired_token"
  resources 'invitations', only: [:new, :create]
end