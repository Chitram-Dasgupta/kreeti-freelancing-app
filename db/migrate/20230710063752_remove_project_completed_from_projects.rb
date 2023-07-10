class RemoveProjectCompletedFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :project_completed, :boolean
  end
end
