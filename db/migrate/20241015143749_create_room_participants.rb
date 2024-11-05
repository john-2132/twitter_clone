# frozen_string_literal: true

class CreateRoomParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :room_participants, id: :uuid do |t|
      t.references :message_room, type: :uuid, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
