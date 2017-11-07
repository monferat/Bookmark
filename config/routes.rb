Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'bookmarkers#index'

  resources :bookmarkers

  # put 'bookmarkers/update_image/:id' => 'bookmarkers#update_image', as: :update_image

  devise_for :users, controllers: { omniauth_callbacks: 'auth/callbacks' }

  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
end
