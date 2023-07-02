class AddProfileDetailsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :username
      t.string :qualification
      t.integer :experience
      t.string :industry
    end
    add_index :users, :username, unique: true
  end
end
