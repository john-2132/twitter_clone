# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'tweets#index'

  resources :tweets, only: %i[index show create] do
    get 'follow', on: :collection
    post 'reply', on: :member
    resources :retweets, shallow: true, only: %i[create destroy]
    resources :favorites, shallow: true, only: %i[create destroy]
    resources :follows, shallow: true, only: %i[create destroy]
  end

  resource :profiles, only: %i[show edit update] do
    get 'reply_and_retweet', on: :collection, to: 'profiles#reply_and_retweet'
    get 'favorite', on: :collection, to: 'profiles#favorite'
  end
end
