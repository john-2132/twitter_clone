# frozen_string_literal: true

class RoomParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :message_room
end
