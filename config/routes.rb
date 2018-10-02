Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :user_sessions, only: %i[new create destroy]
  resources :users, only: %i[new create]

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  scope module: :general do
    root 'dash_boards#index'
    get 'notifications', to: 'notifications#index'
    resources :boards, shallow: true do
      resources :comments, only: %i[create destroy update]
    end
    resources :follows, only: %i[create destroy index]
  end
end
