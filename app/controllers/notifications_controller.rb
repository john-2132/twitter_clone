# frozen_string_literal: true

class NotificationsController < ApplicationController
  def index
    @user = current_user
    @notifications = @user.received_notifications.page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
