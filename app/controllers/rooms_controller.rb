# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :check_user_access, only: [:show]

  def index
    return redirect_to_root('As an admin, you cannot access this page') if admin?

    current_user_id = current_user.id
    @rooms = Room.joins(:user_rooms).where('user_rooms.user1_id = ? OR user_rooms.user2_id = ?', current_user_id,
                                           current_user_id).order('updated_at DESC').page params[:page]
  end

  def show
    @messages = @room.messages
    @other_user = @room.user_rooms.first.other_user(current_user)
  end

  def create
    other_user = User.find(params[:user_id])
    if current_user.role == other_user.role || (admin? || other_user.role == 'admin')
      redirect_to_root('This chat cannot be initiated')
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

  def check_user_access
    @room = Room.find_by(id: params[:id])
    return redirect_to_root('Room not found') if @room.nil?
    return if @room.user_rooms.first.user1_id == current_user.id || @room.user_rooms.first.user2_id == current_user.id

    redirect_to_root('You cannot access this page')
  end

  def redirect_to_root(error_message)
    redirect_to root_path, flash: { error: error_message }
  end
end
