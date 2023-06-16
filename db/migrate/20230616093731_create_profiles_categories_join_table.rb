class CreateProfilesCategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :categories_profiles, id: false do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
    end
  end
end
