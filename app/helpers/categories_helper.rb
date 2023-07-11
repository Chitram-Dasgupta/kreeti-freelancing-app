# frozen_string_literal: true

module CategoriesHelper
  def display_category_action(label, path, icon_name, style, options = {})
    link_to(path, { class: "btn btn-#{style} mt-2" }.merge(options)) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end
end
