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
  get 'tweets/:id', to: 'tweets#show', as: 'tweet_detail'
  post 'tweets/post', to: 'tweets#create'
  post 'tweets/:id/reply', to: 'tweets#reply', as: 'tweet_reply'
  post 'tweets/:id/retweet', to: 'tweets#retweet', as: 'retweet'
  post 'tweets/:id/favorite', to: 'tweets#favorite', as: 'tweet_favorite'
  post 'tweets/:id/user_follow', to: 'tweets#user_follow', as: 'tweet_user_follow'

  get 'profiles/detail', to: 'profiles#show', as: 'profile'
  get 'profiles/edit', to: 'profiles#edit', as: 'edit_profile'
  get 'profiles/reply_and_retweet', to: 'profiles#reply_and_retweet', as: 'reply'
  get 'profiles/favorite', to: 'profiles#favorite', as: 'favorite'
  post 'profiles/update', to: 'profiles#update', as: 'update_profile'
end
