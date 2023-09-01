# frozen_string_literal: true

class ChangeColumnNamesInUserRooms < ActiveRecord::Migration[6.1]
  def change
    rename_column :user_rooms, :sender_id, :sender_id
    rename_column :user_rooms, :receiver_id, :receiver_id
  end
end
