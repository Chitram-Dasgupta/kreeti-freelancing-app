# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
      t.references :bid, null: false, foreign_key: true
      t.string :message, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
