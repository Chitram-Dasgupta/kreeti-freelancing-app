# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms, &:timestamps
  end
end
