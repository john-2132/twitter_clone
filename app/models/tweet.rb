# frozen_string_literal: true

class Tweet < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :text, presence: true
  validate :custom_length_validation

  belongs_to :parent_tweet, class_name: 'Tweet', optional: true, foreign_key: 'parent_id', inverse_of: :replies
  has_many :replies, class_name: 'Tweet', foreign_key: 'parent_id', inverse_of: :parent_tweet, dependent: :destroy

  has_many :notifications, dependent: :destroy

  def favorited?
    favorites.exists?
  end

  def favorite_count
    favorites.count
  end

  def retweeted?
    retweets.exists?
  end

  def retweet_count
    retweets.count
  end

  def bookmarked?
    bookmarks.exists?
  end

  def own?(current_user_id)
    user_id == current_user_id
  end

  def user_followed?(follower_id)
    user.followers.exists?(id: follower_id)
  end

  def self.reply?(tweet)
    Tweet.where(parent_id: tweet.id).count.positive?
  end

  def self.reply_tweets(tweet, order = 'ASC')
    Tweet.where(parent_id: tweet.id).preload(user: { profile: :avatar_attachment }).order(created_at: order)
  end

  def custom_length_validation
    return if text.blank?

    max_length = calculate_max_length(text)

    return unless text.length > max_length

    errors.add(:text, "is too long (maximum is #{max_length} characters)")
  end

  private

  def calculate_max_length(text)
    half_width_count = text.count(' -~｡-ﾟ')
    full_width_count = text.length - half_width_count

    if half_width_count == text.length
      280
    elsif full_width_count == text.length
      140
    else
      (280 * half_width_count + 140 * full_width_count) / text.length
    end
  end
end
