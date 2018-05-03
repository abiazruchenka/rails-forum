Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :sections, except: [:new]
  resources :chapters, except: [:index, :new] do
    resources :topics, except: [:index]
  end
  resources :messages, except: [:show, :new]
  resources :likes, only: [:create]


  root 'sections#index'
  get 'admins/index'
  post 'users/create_user'
  match '*path', :to => 'application#routing_error', :via => [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
