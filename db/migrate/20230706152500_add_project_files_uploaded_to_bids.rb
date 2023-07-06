class AddProjectFilesUploadedToBids < ActiveRecord::Migration[6.1]
  def change
    add_column :bids, :project_files_uploaded, :boolean, default: false, null: false
  end
end
