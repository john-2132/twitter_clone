# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def favorite_notification(notification)
    @notification = notification
    mail(
      to: @notification.recipient.email,
      subject: "#{@notification.recipient.profile.name}さんのツイートにいいねが付きました。"
    )
  end

  def reply_notification(notification)
    @notification = notification
    mail(
      to: @notification.recipient.email,
      subject: "#{@notification.recipient.profile.name}さんのツイートに返信がありました。"
    )
  end

  def retweet_notification(notification)
    @notification = notification
    mail(
      to: @notification.recipient.email,
      subject: "#{@notification.recipient.profile.name}さんのツイートがリツイートされました。"
    )
  end

  def follow_notification(notification)
    @notification = notification
    mail(
      to: @notification.recipient.email,
      subject: "#{@notification.notifier.profile.name}さんからフォローされました。"
    )
  end
end
