# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = current_user
    favorite = @user.favorites.build(tweet_id: params[:tweet_id])

    if favorite.save
      @tweet = Tweet.preload(user: { profile: :avatar_attachment },
                             image_attachment: :blob).find(params[:tweet_id])
      @tweet.notifications.create_notification!(@user.id, @tweet.user.id,
                                                Notification::NOTIFICATION_ACTIONS[:favorite], favorite.tweet_id)
      respond_to do |format|
        format.turbo_stream { render 'favorites/favorite' }
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
    favorite = @user.favorites.find_by(tweet_id: params[:id])

    if favorite.destroy
      @tweet = Tweet.preload(user: { profile: :avatar_attachment },
                             image_attachment: :blob).find(params[:id])
      respond_to do |format|
        format.turbo_stream { render 'favorites/favorite' }
      end
    else
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(parent_id: nil)
                     .order(created_at: 'DESC').page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end
end
