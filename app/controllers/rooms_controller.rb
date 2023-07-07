# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    @rooms = Room.joins(:user_rooms).where('user_rooms.user1_id = ? OR user_rooms.user2_id = ?', current_user.id,
                                           current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
    @other_user = @room.user_rooms.first.other_user(current_user)
  end

  def create
    other_user = User.find(params[:user_id])
    if current_user.role == other_user.role
      redirect_to root_path, flash: { error: 'This chat cannot be initiated' }
    else
      @room = find_or_create_room(other_user)
      redirect_to @room
    end
  end

  private

  def find_or_create_room(other_user)
    user_room = UserRoom.find_by(
      '(user1_id = :current_user AND user2_id = :other_user) OR (user1_id = :other_user AND user2_id = :current_user)',
      current_user: current_user.id, other_user: other_user.id
    )

    unless user_room
      room = Room.create
      user_room = UserRoom.create(user1: current_user, user2: other_user, room:)
    end

    user_room.room
  end
end
