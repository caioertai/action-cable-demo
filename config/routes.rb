Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :users, only: [] do
    post "wave", on: :member
  end
end
