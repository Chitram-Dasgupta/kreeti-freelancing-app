# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.integer :visibility, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
