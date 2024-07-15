# frozen_string_literal: true

class TweetsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :authenticate_user!, only: [:index]

  def index
    @user = current_user
    @tweets = Tweet.preload(:user).order(created_at: 'DESC').page(params[:page])
  end

  def follow # rubocop:disable Hc/RailsSpecificActionName
    @user = current_user
    @follow_tweets = Tweet.preload(:user).where(user_id: @user.followings)
                          .order(created_at: 'DESC').page(params[:page])
    render layout: false, content_type: 'text/vnd.turbo-stream.html'
  end
end
