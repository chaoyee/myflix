Myflix::Application.routes.draw do
  root to: 'pages#front' # 'videos#index'

  resources :videos, only: [:show, :index] do
    collection do    
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end 
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: "videos#index"
  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  post 'sign_in', to: 'sessions#create'
  get  'sign_out', to: 'sessions#destory'
  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy]
  resources :queue_items, only: [:index, :create, :destroy]
  post 'update_queue', to: "queue_items#update_queue"
end
