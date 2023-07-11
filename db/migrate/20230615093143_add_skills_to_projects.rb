# frozen_string_literal: true

class AddSkillsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :skills, :text, array: true, default: []
  end
end
