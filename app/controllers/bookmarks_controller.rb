# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @bookmark_tweets = @user.bookmark_tweets.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                            .order(created_at: 'DESC').page(params[:page])
  end

  def create
    @user = current_user
    bookmark = @user.bookmarks.build(tweet_id: params[:tweet_id])

    if bookmark.save
      @tweet = Tweet.preload(user: { profile: :avatar_attachment },
                             image_attachment: :blob).find(params[:tweet_id])
      respond_to do |format|
        format.turbo_stream { render 'bookmarks/bookmark' }
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
    bookmark = @user.bookmarks.find_by(tweet_id: params[:id])

    if bookmark.destroy
      @tweet = Tweet.preload(user: { profile: :avatar_attachment },
                             image_attachment: :blob).find(params[:id])
      respond_to do |format|
        format.turbo_stream { render 'bookmarks/bookmark' }
      end
    else
      @tweets = Tweet.preload(user: { profile: :avatar_attachment }, image_attachment: :blob)
                     .where(parent_id: nil)
                     .order(created_at: 'DESC').page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end
end
