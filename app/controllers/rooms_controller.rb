class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms
    @users = User.where.not(id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
  end

  def start_conversation
    other_user = User.find(params[:user_id])
    existing_room = UserRoom.where(
      '(user1_id = :current_user AND user2_id = :other_user) OR (user1_id = :other_user AND user2_id = :current_user)',
      current_user: current_user.id, other_user: other_user.id
    ).first

    if existing_room
      @room = existing_room.room
    else
      @room = Room.new
      if @room.save
        UserRoom.create(user1: current_user, user2: other_user, room: @room)
      else
        redirect_to rooms_path, flash: { error: 'Something went wrong' }
      end
    end

    redirect_to @room
  end

  # private

  # def find_room(user1, user2)
  #   (user1.rooms & user2.rooms).first
  # end

  # def create_room(user1, user2)
  #   room = Room.new
  #   return unless room.save

  #   UserRoom.create(user: user1, room:)
  #   UserRoom.create(user: user2, room:)
  #   room
  # end
end
