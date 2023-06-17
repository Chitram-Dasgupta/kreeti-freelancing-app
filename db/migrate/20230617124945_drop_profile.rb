class DropProfile < ActiveRecord::Migration[6.1]
  def change
    drop_table :profiles do |t|
      t.string :name
      t.string :qualification
      t.integer :experience
      t.string :industry
      t.string :profile_picture
      t.references :user, null: false, foreign_key: true
      t.timestamps null: false
    end
  end
end
