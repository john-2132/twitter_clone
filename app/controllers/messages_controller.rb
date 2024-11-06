# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @message_rooms = @user.message_rooms.ordered_by_latest_message.page(params[:page])
    @message_room = MessageRoom.find(params[:message_room_id])
    @messages = Message.where(message_room_id: params[:message_room_id]).order(:created_at).page(params[:page])
  end

  def create
    @user = current_user
    @message_room = MessageRoom.find(params[:message_room_id])
    @message = @message_room.messages.build(message_params)
    if @message.save
      @message.broadcast_append_to "message-room-#{@message_room.id}",
                                   target: 'messages',
                                   partial: 'messages/message',
                                   locals: { user: @user, message: @message }
      @message_room.broadcast_replace_to 'message-rooms',
                                         target: "latest-message-#{@message_room.id}",
                                         partial: 'message_rooms/latest_message',
                                         locals: { message_room: @message_room }
    else
      @message_room = MessageRoom.find(params[:message_room_id])
      @message_rooms = @user.message_rooms.page(params[:page])
      @messages = Message.where(message_room_id: params[:message_room_id]).page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:text).merge(user: current_user)
  end
end
