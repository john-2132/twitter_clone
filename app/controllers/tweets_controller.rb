# frozen_string_literal: true

class TweetsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :authenticate_user!

  def index
    @user = current_user
    @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                   .where(parent_id: nil)
                   .order(created_at: 'DESC').page(params[:page])
  end

  def create
    @user = current_user
    @tweet = @user.tweets.build(tweet_params)

    return if @tweet.save

    @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                   .where(parent_id: nil)
                   .order(created_at: 'DESC').page(params[:page])

    render :index, status: :unprocessable_entity
  end

  def follow # rubocop:disable Hc/RailsSpecificActionName
    @user = current_user
    @follow_tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                          .where(user_id: @user.followings).where(parent_id: nil)
                          .order(created_at: 'DESC').page(params[:page])
  end

  def show
    @user = current_user
    @tweet = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob).find(params[:id])
    @reply_tweets = Tweet.reply_tweets(@tweet, 'DESC').page(params[:page])
  end

  def reply # rubocop:disable Hc/RailsSpecificActionName
    @user = current_user
    @reply_tweet = @user.tweets.build(tweet_params)
    @reply_tweet.parent_id = params[:id]

    @tweet = Tweet.preload(user: { profile: :avatar_attachment },
                           image_attachment: :blob).find(params[:id])

    is_saved = @reply_tweet.save
    @reply_tweets = Tweet.reply_tweets(@tweet, 'DESC').page(params[:page])

    render :show, status: :unprocessable_entity unless is_saved
  end

  private

  def tweet_params
    params.require(:tweet).permit(:text, :image)
  end
end
