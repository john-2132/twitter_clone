# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = current_user
    follow = @user.active_follows.build(followed_id: params[:tweet_id])

    if follow.save
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(user_id: params[:tweet_id])
                     .order(created_at: 'DESC')
      respond_to do |format|
        format.turbo_stream { render 'follows/follow' }
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
    follow = @user.active_follows.find_by(followed_id: params[:id])

    if follow.destroy
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(user_id: params[:id])
                     .order(created_at: 'DESC')
      respond_to do |format|
        format.turbo_stream { render 'follows/follow' }
      end
    else
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(parent_id: nil)
                     .order(created_at: 'DESC').page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end
end
