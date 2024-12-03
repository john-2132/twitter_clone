# frozen_string_literal: true

class SendFavoriteNotificationEmailJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find(notification_id)
    NotificationMailer.favorite_notification(notification).deliver_later
  end
end
