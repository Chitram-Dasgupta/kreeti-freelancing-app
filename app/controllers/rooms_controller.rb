# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :check_user_access, only: [:show]

  def index
    return redirect_to_root_with_err('As an admin, you cannot access this page') if admin?

    @rooms = Room.for_user(current_user.id).page params[:page]
  end

  def show
    @messages = @room.messages
    @other_user = @room.user_rooms.first.other_user(current_user)
  end

  def create
    other_user = User.find_by(id: params[:user_id])
    return redirect_to_root_with_err('User not found') if other_user.nil?

    if current_user.role == other_user.role || (admin? || other_user.admin?)
      redirect_to_root_with_err('This chat cannot be initiated')
    else
      redirect_to find_or_create_room(other_user)
    end
  end

  private

  def find_or_create_room(other_user)
    user_room = UserRoom.find_by(
      '(sender_id = :current_user AND receiver_id = :other_user)
      OR (sender_id = :other_user AND receiver_id = :current_user)',
      current_user: current_user.id, other_user: other_user.id
    )

    unless user_room
      room = Room.create
      user_room = UserRoom.create(sender_id: current_user.id, receiver_id: other_user.id, room:)
    end

    user_room.room
  end

  def check_user_access
    @room = Room.find_by(id: params[:id])
    return redirect_to_root_with_err('Room not found') if @room.nil?
    return if @room.user_rooms.belongs_to_user(current_user).exists?

    redirect_to_root_with_err('You cannot access this page')
  end
end
