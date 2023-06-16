class CreateUsersCategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :categories_users, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
    end
  end
end
