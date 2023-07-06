class CreateBids < ActiveRecord::Migration[6.1]
  def change
    create_table :bids do |t|
      t.string :bid_name, null: false
      t.text :bid_description
      t.integer :bid_status, default: 0
      t.decimal :bid_amount, precision: 8, scale: 2, null: false
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :bids, %i[user_id project_id], unique: true
  end
end
