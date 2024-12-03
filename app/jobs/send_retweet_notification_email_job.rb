# frozen_string_literal: true

class SendRetweetNotificationEmailJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find(notification_id)
    NotificationMailer.retweet_notification(notification).deliver_later
  end
end
