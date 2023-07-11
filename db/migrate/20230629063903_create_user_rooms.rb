# frozen_string_literal: true

class CreateUserRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :user_rooms do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
