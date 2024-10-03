# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  # after_initialize :build_profile, if: :new_record?

  has_many :tweets, dependent: :destroy

  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy,
                             inverse_of: :followed
  has_many :followings, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  has_many :retweets, dependent: :destroy
  has_many :retweet_tweets, through: :retweets, source: :tweet

  has_many :favorites, dependent: :destroy
  has_many :favorite_tweets, through: :favorites, source: :tweet

  def replies_and_retweets
    reply_ids = tweets.select(:parent_id).where.not(parent_id: nil).pluck(:parent_id)
    retweet_ids = retweets.pluck(:tweet_id)
    Tweet.where(id: [*reply_ids, *retweet_ids]).preload(user: { profile: :avatar_attachment },
                                                        image_attachment: :blob).order(created_at: :desc)
  end

  def favorited_tweet?(tweet_id)
    favorites.exists?(tweet_id:)
  end

  def retweeted_tweet?(tweet_id)
    retweets.exists?(tweet_id:)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, omniauth_providers: %i[github]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.profile.name = auth.info.name
    end
  end

  with_options unless: -> { validation_context == :omniauth } do
    validates :uid, uniqueness: { scope: :provider }
  end
end
