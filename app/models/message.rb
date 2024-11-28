# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :message_room
  validates :text, presence: true

  def own?(current_user_id)
    user_id == current_user_id
  end
end
