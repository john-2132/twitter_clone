# frozen_string_literal: true

class Notification < ApplicationRecord
  NOTIFICATION_ACTIONS = {
    follow: 0,
    favorite: 1,
    retweet: 2,
    reply: 3
  }.freeze
  enum action: NOTIFICATION_ACTIONS

  SEND_NOTIFICATION_MAIL_JOBS = {
    NOTIFICATION_ACTIONS[:follow] => SendFollowNotificationEmailJob,
    NOTIFICATION_ACTIONS[:favorite] => SendFavoriteNotificationEmailJob,
    NOTIFICATION_ACTIONS[:retweet] => SendRetweetNotificationEmailJob,
    NOTIFICATION_ACTIONS[:reply] => SendReplyNotificationEmailJob
  }.freeze
  enum job: SEND_NOTIFICATION_MAIL_JOBS

  default_scope -> { order(created_at: :desc) }

  belongs_to :tweet, optional: true
  belongs_to :reply, class_name: 'Tweet', optional: true

  belongs_to :notifier, class_name: 'User', foreign_key: 'from_user_id', inverse_of: :sent_notifications
  belongs_to :recipient, class_name: 'User', foreign_key: 'to_user_id', inverse_of: :received_notifications

  def self.create_notification!(from_user_id, to_user_id, action, tweet_id = nil, reply_id = nil)
    notification = Notification.unscoped.find_or_initialize_by(from_user_id:, to_user_id:,
                                                               action:, tweet_id:, reply_id:)

    return if notification.persisted?

    notification.checked = true if notification.from_user_id == notification.to_user_id
    return unless notification.valid?

    notification.save
    return if notification.checked

    SEND_NOTIFICATION_MAIL_JOBS[action].perform_later(notification.id)
  end

  def self.create_reply_notification!(from_user_id, tweet_id, reply_id)
    user_ids = fetch_reply_chain_users(reply_id)
    create_reply_notifications_for_users(user_ids, from_user_id, tweet_id, reply_id)
  end

  def self.fetch_reply_chain_users(reply_id)
    query = <<-SQL
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
    ActiveRecord::Base.connection.exec_query(query, 'SQL', [reply_id]).map { |row| row['user_id'] }
  end

  def self.create_reply_notifications_for_users(user_ids, from_user_id, tweet_id, reply_id)
    user_ids.reject { |user_id| user_id == from_user_id }.each do |user_id|
      create_notification!(from_user_id, user_id, NOTIFICATION_ACTIONS[:reply], tweet_id, reply_id)
    end
  end
end
