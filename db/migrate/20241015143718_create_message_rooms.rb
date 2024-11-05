# frozen_string_literal: true

class CreateMessageRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :message_rooms, id: :uuid, &:timestamps
  end
end
