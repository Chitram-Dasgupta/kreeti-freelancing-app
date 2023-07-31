# frozen_string_literal: true

class RemoveVisibilityFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :visibility, :integer
  end
end
