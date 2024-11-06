# frozen_string_literal: true

class MessageRoom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :room_participants, dependent: :destroy
  has_many :users, through: :room_participants

  scope :ordered_by_latest_message, lambda {
    left_joins(:messages)
      .group('message_rooms.id')
      .order('MAX(messages.created_at) DESC')
  }

  def latest_message
    messages.order(created_at: :desc).first
  end

  def other_users(current_user)
    users.where.not(id: current_user.id).preload(profile: { avatar_attachment: :blob })
  end
end
