# frozen_string_literal: true

class TweetsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :authenticate_user!

  def index
    @user = current_user
    @tweets = Tweet.preload(user: { profile: :avatar_attachment }).where(parent_id: nil)
                   .order(created_at: 'DESC').page(params[:page])
  end

  def create
    @user = current_user
    @tweet = Tweet.new(text: tweet_params[:tweet], user_id: @user.id)

    return if @tweet.save

    @tweets = Tweet.preload(user: { profile: :avatar_attachment }).where(parent_id: nil)
                   .order(created_at: 'DESC').page(params[:page])

    render :index, status: :unprocessable_entity
  end

  def follow # rubocop:disable Hc/RailsSpecificActionName
    @user = current_user
    @follow_tweets = Tweet.preload(user: { profile: :avatar_attachment })
                          .where(user_id: @user.followings).where(parent_id: nil)
                          .order(created_at: 'DESC').page(params[:page])
  end

  private

  def tweet_params
    params.require(:tweet).permit(:tweet)
  end
end
