class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
      t.references :bid, null: false, foreign_key: true
      t.integer :bid_status
      t.boolean :read

      t.timestamps
    end
  end
end
