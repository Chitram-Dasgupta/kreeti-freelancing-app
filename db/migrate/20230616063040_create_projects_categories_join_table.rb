class CreateProjectsCategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :categories_projects, id: false do |t|
      t.references :project, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
    end
  end
end
