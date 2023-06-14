class CreateBids < ActiveRecord::Migration[6.1]
  def change
    create_table :bids do |t|
      t.string :bid_name, null: false
      t.text :bid_description
      t.integer :bid_status
      t.decimal :bid_amount, precision: 8, scale: 2
      t.string :bid_code_document
      t.string :bid_design_document
      t.string :bid_other_document
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
