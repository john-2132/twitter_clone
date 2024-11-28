# frozen_string_literal: true

class SendReplyNotificationEmailJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find(notification_id)
    NotificationMailer.reply_notification(notification).deliver_later
  end
end
