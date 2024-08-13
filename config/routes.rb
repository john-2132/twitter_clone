# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'tweets#index'
  get 'tweets', to: 'tweets#index'
  get 'tweets/folllow', to: 'tweets#follow'
  get 'profiles/detail', to: 'profiles#show', as: 'profile'
  get 'profiles/reply_and_retweet', to: 'profiles#reply_and_retweet', as: 'reply'
  get 'profiles/favorite', to: 'profiles#favorite', as: 'favorite'
end
