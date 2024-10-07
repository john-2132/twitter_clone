# frozen_string_literal: true

class RetweetsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = current_user
    retweet = @user.retweets.build(tweet_id: params[:tweet_id])

    if retweet.save
      @tweet = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob).find(params[:tweet_id])
      respond_to do |format|
        format.turbo_stream { render 'retweets/retweet' }
      end
    else
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(parent_id: nil)
                     .order(created_at: 'DESC').page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    retweet = @user.retweets.find_by(tweet_id: params[:id])

    if retweet.destroy
      @tweet = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob).find(params[:id])
      respond_to do |format|
        format.turbo_stream { render 'retweets/retweet' }
      end
    else
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(parent_id: nil)
                     .order(created_at: 'DESC').page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end
end
