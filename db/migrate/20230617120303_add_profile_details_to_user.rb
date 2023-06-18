class AddProfileDetailsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :name
      t.string :qualification
      t.integer :experience
      t.string :industry
      t.string :profile_picture
    end
  end
end
