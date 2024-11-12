# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :message_room
  validates :text, presence: true

  # after_create_commit do
  #   broadcast_append_to 'messages',
  #                       target: :message_room,
  #                       partial: 'messages/message',
  #                       locals: { user: @user, message: @message }
  # end

  def own?(current_user_id)
    user_id == current_user_id
  end
end
