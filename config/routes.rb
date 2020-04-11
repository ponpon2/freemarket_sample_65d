Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  resources :signup do
    collection do
      get 'index'
    end
  end
  devise_scope :user do
    get 'sending_destinations', to: 'users/registrations#new_sending_destination'
    post 'sending_destinations', to: 'users/registrations#create_sending_destination'
  end

  root 'items#index'

  namespace :api do
    resources :items, only: :index, defaults: { format: 'json' }
  end

  resources :mypage, only: [:index] do
    collection do
      delete 'logout' 
    end
  end

  namespace :mypage do
    get 'sending_destinations/edit'
    patch 'sending_destinations/update'
    get 'cards/show'
    post 'cards/delete'
    get 'cards/index'
    get 'cards/new'
    post 'cards/pay'
    get 'accounts/edit'
    patch 'accounts/update'
  end

  resources :items do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end

    member do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
  end
  
  resources :purchases

  resources :cards, only: [:index, :new, :show] do
    collection do
      post 'show', to: 'cards#show'
      post 'pay', to: 'cards#pay'
      post 'delete', to: 'cards#delete'
      post 'buy', to: 'cards#buy'
    end
  end
end

