# frozen_string_literal: true

class MessageRoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    @message_rooms = @user.message_rooms.ordered_by_latest_message.page(params[:page])
  end

  def show; end

  def new
    @user = current_user
  end

  def create
    @user = current_user
    @message_rooms = @user.message_rooms.page(params[:page])
    user_ids = [@user.id, params[:to_user_ids].map(&:to_i)].flatten.sort

    @message_room = MessageRoom.joins(:room_participants)
                               .group('message_rooms.id')
                               .having('ARRAY_AGG(room_participants.user_id ORDER BY room_participants.user_id) = ARRAY[?]::bigint[]', user_ids) # rubocop:disable Layout/LineLength
                               .first

    if @message_room.nil?
      ActiveRecord::Base.transaction do
        @message_room = MessageRoom.create!
        user_ids.each do |user_id|
          @message_room.room_participants.create!(user_id:)
        end
      end
    end

    redirect_to message_room_messages_path(@message_room)
  end
end
