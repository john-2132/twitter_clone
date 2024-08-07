# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy

  belongs_to :parent_tweet, class_name: 'Tweet', optional: true, foreign_key: 'parent_id', inverse_of: :replies
  has_many :replies, class_name: 'Tweet', foreign_key: 'parent_id', inverse_of: :parent_tweet, dependent: :destroy

  def self.reply?(tweet)
    Tweet.where(parent_id: tweet.id).count.positive?
  end

  def self.reply_tweets(tweet)
    Tweet.where(parent_id: tweet.id).preload(user: { profile: :avatar_attachment }).order(created_at: 'ASC')
  end
end
