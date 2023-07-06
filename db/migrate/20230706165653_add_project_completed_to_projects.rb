class AddProjectCompletedToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :project_completed, :boolean, default: false, null: false
  end
end
