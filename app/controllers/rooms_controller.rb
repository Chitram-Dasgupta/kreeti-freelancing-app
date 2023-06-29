class RoomsController < ApplicationController
  def index
    if current_user.rooms.empty?
      @room = Room.new
      UserRoom.create(user: current_user, room: @room) if @room.save
    end
    @rooms = Room.all
    @users = User.all
  end

  def show
    other_user = User.find(params[:id])
    @room = find_room(current_user, other_user) || create_room(current_user, other_user)
  end

  private

  def find_room(user1, user2)
    (user1.rooms & user2.rooms).first
  end

  def create_room(user1, user2)
    room = Room.new
    return unless room.save

    UserRoom.create(user: user1, room:)
    UserRoom.create(user: user2, room:)
    room
  end
end
