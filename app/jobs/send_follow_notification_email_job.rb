# frozen_string_literal: true

class SendFollowNotificationEmailJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find(notification_id)
    NotificationMailer.follow_notification(notification).deliver_later
  end
end
