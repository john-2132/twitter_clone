# frozen_string_literal: true

module NotificationsHelper
  def unchecked_notifications
    current_user.received_notifications.where(checked: false)
  end
end
