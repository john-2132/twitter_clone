# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_profile

  def show
    @own_tweets = Tweet.preload(user: { profile: :avatar_attachment }).where(user_id: @user.id)
                       .where(parent_id: nil).order(created_at: 'DESC').page(params[:page])
  end

  def reply_and_retweet # rubocop:disable Hc/RailsSpecificActionName
    @replies_and_retweets = @user.replies_and_retweets(@user.id).page(params[:page])
  end

  def favorite # rubocop:disable Hc/RailsSpecificActionName
    @favorite_tweets = @user.favorite_tweets.preload(user: { profile: :avatar_attachment })
                            .order(created_at: 'DESC').page(params[:page])
  end

  private

  def current_user_profile
    @user = current_user
    @profile = Profile.find(@user.id)
  end
end
