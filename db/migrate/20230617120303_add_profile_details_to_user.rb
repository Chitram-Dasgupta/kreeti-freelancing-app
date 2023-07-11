# frozen_string_literal: true

class AddProfileDetailsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :username, null: false
      t.string :qualification
      t.integer :experience
      t.string :industry
      t.integer :visibility, default: 0
    end
    add_index :users, :username, unique: true
  end
end
