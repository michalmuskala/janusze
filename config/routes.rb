Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users' }

  root to: 'home#index'

  get 'projects/tags' => 'projects#tags'

  resources :projects do
    resources :comments, only: [:create], shallow: true do
      put :upvote, on: :member
      put :downvote, on: :member
    end
  end

  resources :users, :only => [:show]
end
