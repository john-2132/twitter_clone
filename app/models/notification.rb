# frozen_string_literal: true

class Notification < ApplicationRecord
  NOTIFICATION_ACTIONS = {
    follow: 0,
    favorite: 1,
    retweet: 2,
    reply: 3
  }.freeze
  enum action: NOTIFICATION_ACTIONS

  default_scope -> { order(created_at: :desc) }

  belongs_to :tweet, optional: true
  belongs_to :reply, class_name: 'Tweet', optional: true

  belongs_to :notifier, class_name: 'User', foreign_key: 'from_user_id', inverse_of: :sent_notifications
  belongs_to :recipient, class_name: 'User', foreign_key: 'to_user_id', inverse_of: :received_notifications

  def self.create_favorite_notification!(from_user_id, to_user_id, tweet_id)
    notification = Notification.find_or_initialize_by(from_user_id:, to_user_id:, tweet_id:,
                                                      action: NOTIFICATION_ACTIONS[:favorite])

    return unless notification.new_record?

    notification.checked = true if notification.from_user_id == notification.to_user_id
    return unless notification.valid?

    notification.save
    return if notification.checked

    SendFavoriteNotificationEmailJob.perform_later(notification.id)
  end

  def self.create_reply_notification!(from_user_id, tweet_id, reply_id)
    user_ids = fetch_reply_chain_users(reply_id)
    create_notifications_for_users(user_ids, from_user_id, tweet_id, reply_id)
  end

  def self.create_retweet_notification!(from_user_id, to_user_id, tweet_id)
    notification = Notification.find_or_initialize_by(from_user_id:, to_user_id:, tweet_id:,
                                                      action: NOTIFICATION_ACTIONS[:retweet])
    return unless notification.new_record?

    notification.checked = true if notification.from_user_id == notification.to_user_id
    notification.save if notification.valid?
    return if notification.checked

    SendRetweetNotificationEmailJob.perform_later(notification.id)
  end

  def self.create_follow_notification!(from_user_id, to_user_id)
    notification = Notification.find_or_initialize_by(from_user_id:, to_user_id:,
                                                      action: NOTIFICATION_ACTIONS[:follow])
    return unless notification.new_record?

    notification.checked = true if notification.from_user_id == notification.to_user_id
    return unless notification.valid?

    notification.save
    return if notification.checked

    SendFollowNotificationEmailJob.perform_later(notification.id)
  end

  def self.fetch_reply_chain_users(reply_id)
    query = build_reply_chain_query
    ActiveRecord::Base.connection.exec_query(query, 'SQL', [reply_id]).map { |row| row['user_id'] }
  end

  def self.build_reply_chain_query
    <<-SQL
      WITH RECURSIVE reply_chain AS (
        SELECT id, user_id, parent_id
        FROM tweets
        WHERE id = $1
        UNION ALL
        SELECT t.id, t.user_id, t.parent_id
        FROM tweets t
        INNER JOIN reply_chain rc ON t.id = rc.parent_id
      )
      SELECT DISTINCT user_id
      FROM reply_chain;
    SQL
  end

  def self.create_notifications_for_users(user_ids, from_user_id, tweet_id, reply_id)
    user_ids.reject { |user_id| user_id == from_user_id }.each do |user_id|
      create_single_notification(from_user_id, user_id, tweet_id, reply_id)
    end
  end

  def self.create_single_notification(from_user_id, to_user_id, tweet_id, reply_id)
    notification = new(
      from_user_id:,
      to_user_id:,
      tweet_id:,
      reply_id:,
      action: NOTIFICATION_ACTIONS[:reply]
    )
    return unless notification.valid?

    notification.save
    SendReplyNotificationEmailJob.perform_later(notification.id)
  end
end
