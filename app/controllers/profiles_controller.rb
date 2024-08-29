# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_profile

  def show
    @own_tweets = Tweet.preload(user: { profile: :avatar_attachment }).where(user_id: @user.id)
                       .where(parent_id: nil).order(created_at: 'DESC').page(params[:page])
  end

  def edit; end

  def update
    @profile.avatar.purge if params[:profile][:avatar_id]
    @profile.header.purge if params[:profile][:header_id]
    if @profile.update(profile_params)
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
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

  def profile_params
    params.require(:profile).permit(:name, :self_introduction, :place, :web_site, :header, :avatar)
  end
end
