Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users' }

  root to: 'static#home'

  resources :projects do
    resources :comments, only: [:create]
  end

  resources :users, :only => [:show]
end
